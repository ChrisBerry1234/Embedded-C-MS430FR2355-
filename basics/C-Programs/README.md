# MSP430 SPI Loopback Example (eUSCI_A0)

This project demonstrates how to configure the MSP430 LaunchPad’s **eUSCI_A0 peripheral as an SPI master** and perform a simple **SPI loopback test** using only the onboard hardware. Button presses transmit specific bytes, and received bytes toggle LEDs through an interrupt-driven workflow.

---

## Overview

The MSP430 is set up as an SPI master. A jumper wire connects **SIMO → SOMI**, allowing transmitted data to be immediately received. When buttons S1 or S2 are pressed, the SPI module sends predefined bytes. The RX interrupt reads the incoming data and toggles LEDs based on the value.

**Behavior Summary:**
- Press **S1** → transmit `0x10` → receiving `0x10` toggles **LED1**
- Press **S2** → transmit `0x66` → receiving `0x66` toggles **LED2`

This setup allows full SPI testing without any external SPI device.

---

## Hardware Setup

Connect the following pins on the LaunchPad header:

| Signal | MSP430 Pin | Header |
|--------|------------|--------|
| SIMO   | P1.6       | J1     |
| SOMI   | P1.7       | J1     |

**Use a jumper wire to connect SIMO → SOMI.**

No external components are required.

---

## Software Behavior

### Button → Transmitted Byte
| Button | Byte |
|--------|------|
| S1     | `0x10` |
| S2     | `0x66` |

### RX Interrupt Workflow
1. SPI receives a byte.
2. RXIFG flag asserts.
3. ISR reads the RX buffer.
4. LED toggles based on received value:
   - `0x10` → LED1 toggle  
   - `0x66` → LED2 toggle

## Running the Example

1. Import the project into Code Composer Studio or TI Clang.
2. Flash the program to the MSP430 LaunchPad.
3. Connect **SIMO → SOMI** with a jumper.
4. Press S1 or S2 and observe LED toggling.

---

## eUSCI_A0 SPI Configuration (Summary)

- Mode: SPI Master  
- Clock Mode: Default (Mode 0)  
- Bit Order: MSB first  
- Clock Source: SMCLK  
- Interrupts: RX interrupt enabled  

---

## Notes

- This example is ideal for verifying SPI configuration without external hardware.
- You can extend it later by connecting a real SPI slave device.
