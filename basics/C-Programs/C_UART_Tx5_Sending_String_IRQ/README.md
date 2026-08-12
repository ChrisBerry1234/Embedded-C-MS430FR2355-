# UART Example — Interrupt‑Driven Transmission (115200 Baud)

This example sends the string **"Hello World"** from the **eUSCI_A1** UART each time button **S1** is pressed on the LaunchPad. Transmission is controlled using the **Tx Complete interrupt (UCTXCPTIFG)** so each character is loaded into the transmit buffer only after the previous one finishes.

---

## UART Configuration

- **Module:** eUSCI_A1  
- **Baud Rate:** 115200  
- **Clock Source:** SMCLK = 1 MHz  
- **Divider:** `UCA1BRW = 8`  
- **Modulation:** `UCA1MCTLW = 0xD600`  
- **TX Pin:** P4.3 (UCA1TXD)  
  - `P4SEL1 &= ~(BIT3);`  
  - `P4SEL0 |=  (BIT3);`

---

## Interrupts Used

- **UCTXIFG** — indicates TX buffer is ready  
- **UCTXCPTIFG** — indicates transmission of the current byte is complete  
- **UCIV** — interrupt vector register used to identify which UART interrupt fired

The program waits for **S1** to be pressed, then sends characters one at a time. Each new character is written to `UCA1TXBUF` only when **UCTXCPTIFG** asserts.

---

## Basic Flow

1. Configure UART for 115200 baud using SMCLK.  
2. Enable UART TX interrupts.  
3. Wait for button S1 press.  
4. On press, begin sending `"Hello World"` one byte at a time.  
5. Each time **UCTXCPTIFG** fires, load the next character.  
6. Repeat whenever S1 is pressed.

---

## Summary

- Baud: **115200**  
- Clock: **SMCLK = 1 MHz**  
- Divider: **8**  
- Modulation: **0xD600**  
- TX Pin: **P4.3**  
- Transmission controlled by **Tx Complete interrupt**

