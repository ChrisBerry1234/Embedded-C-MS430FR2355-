# MSP430FR2355 - GPIO Interrupts (Port Interrupt Example)

## Polling vs. Interrupts

### Polling

Polling continuously checks the state of an input pin.

Example:

* **S1** is connected to **P4.1**
* Read the switch state using **P4IN.1**
* If the button is pressed (logic goes low because of the pull-up resistor), toggle the LED.

```assembly
bit.b   #BIT1, &P4IN
jnz     poll          ; Keep checking until button is pressed
```

Polling works well for simple programs but wastes CPU time because the processor constantly checks the input.

---

# Using GPIO Interrupts

Instead of constantly checking `P4IN`, the MCU can wait until a hardware event occurs. When the selected edge is detected, the processor automatically jumps to the Interrupt Service Routine (ISR).

---

## GPIO Interrupt Configuration Steps

### 1. Configure the GPIO Peripheral

Configure the input pin just like polling:

* Set port direction (`PxDIR`)
* Enable pull-up/pull-down resistor (`PxREN`)
* Select pull-up or pull-down (`PxOUT`)

Example:

```assembly
bic.b   #BIT1, &P4DIR      ; P4.1 = input
bis.b   #BIT1, &P4REN      ; Enable resistor
bis.b   #BIT1, &P4OUT      ; Configure as pull-up
```

---

### 2. Configure Edge Sensitivity (`PxIES`)

`PxIES` selects which signal transition generates an interrupt.

* `PxIES = 0` → Low → High transition (rising edge)
* `PxIES = 1` → High → Low transition (falling edge)

Since S1 uses a pull-up resistor:

* Not pressed → Logic High
* Pressed → Logic Low

Configure for a **High-to-Low (falling edge)** interrupt:

```assembly
bis.b   #BIT1, &P4IES
```

---

### 3. Clear LOCKLPM5

Enable digital I/O.

```assembly
bic.b   #LOCKLPM5, &PM5CTL0
```

---

### 4. Enable the Interrupt

Before enabling interrupts:

1. Clear any existing interrupt flag (`PxIFG`)
2. Enable the local interrupt (`PxIE`)
3. Enable global maskable interrupts (`GIE` in the Status Register)

Example:

```assembly
bic.b   #BIT1, &P4IFG      ; Clear interrupt flag
bis.b   #BIT1, &P4IE       ; Enable Port 4.1 interrupt
bis.w   #GIE, SR           ; Enable global interrupts
```

---

### 5. Create the Interrupt Service Routine (ISR)

Associate the ISR with the correct Port 4 interrupt vector (found in the MSP430FR2355 vector table or CCS startup file).

Typical ISR tasks:

* Determine which pin generated the interrupt.
* Perform the required action (toggle LED, read input, etc.).
* Clear the interrupt flag.
* Return using `RETI`.

Example:

```assembly
P4_ISR:
    xor.b   #BIT0, &P1OUT      ; Toggle LED

    bic.b   #BIT1, &P4IFG      ; Clear interrupt flag

    reti
```

---

# Port Interrupt Registers Summary

| Register | Purpose                                       |
| -------- | --------------------------------------------- |
| `PxDIR`  | Configure pin as input or output              |
| `PxREN`  | Enable internal pull-up/pull-down resistor    |
| `PxOUT`  | Select pull-up or pull-down resistor          |
| `PxIN`   | Read input logic level                        |
| `PxIES`  | Select interrupt edge (rising/falling)        |
| `PxIFG`  | Interrupt flag (set when an interrupt occurs) |
| `PxIE`   | Local interrupt enable                        |

---

# Interrupt Initialization Checklist

* Configure `PxDIR`
* Configure `PxREN`
* Configure `PxOUT`
* Configure `PxIES`
* Clear `LOCKLPM5`
* Clear `PxIFG`
* Enable `PxIE`
* Enable global interrupts (`GIE`)
* Implement ISR
* End ISR with `RETI`

---

## Key Idea

**Polling:** The CPU repeatedly checks the input (`P4IN`) in a loop.

**Interrupts:** The CPU performs other work (or sleeps) until the selected edge occurs. Hardware sets `PxIFG`, and if both `PxIE` and `GIE` are enabled, the processor automatically jumps to the ISR.
