# MSP430 UART Configuration — 115200 Baud (SMCLK = 1 MHz)

This README documents how to configure the MSP430 eUSCI_A UART module to transmit data at **115200 baud** using **SMCLK = 1 MHz** in **low‑frequency mode (UCOS16 = 0)**.

---

## 📡 Overview

The MSP430 UART baud rate generator uses:

- **UCAxBRW** — integer prescaler  
- **UCAxMCTLW** — modulation control  
  - **UCBRFx** — first modulator (only used when UCOS16 = 1)  
  - **UCBRSx** — second modulator (used in both modes)  
- **UCOS16** — oversampling enable bit  

For **115200 baud @ 1 MHz**, TI recommends **low‑frequency mode**, meaning:

- **UCBRFx is ignored**
- **Only UCBRSx is used**

---

## 🔢 Baud Rate Calculation

### 1. Compute N



\[
N = \frac{BRCLK}{\text{Baud}} = \frac{1{,}000{,}000}{115{,}200} \approx 8.68
\]



### 2. Integer Divider



\[
UCBRx = 8
\]



Stored in:

UCAxBRW = 8


### 3. Fractional Portion



\[
\text{fraction} = 0.68
\]



In **low‑frequency mode**, this fractional part **does not** produce a UCBRFx value.

---

## 🎛 Modulation Settings

### UCBRFx (First Modulator)

Disabled because **UCOS16 = 0**:

UCBRFx = 0   // ignored


### UCBRSx (Second Modulator)

TI’s baud rate modulation table specifies:

UCBRSx = 0xD6


This produces:

UCAxMCTLW = 0xD600


Breakdown:

- Bits 15–8 → **UCBRSx = 0xD6**
- Bits 7–4 → **UCBRFx = 0**
- Bit 0 → **UCOS16 = 0**

---

## 🛠 Final Register Configuration

```c
UCA1CTLW0 |= UCSSEL__SMCLK;   // Select SMCLK (1 MHz)
UCA1BRW    = 8;               // Integer divider
UCA1MCTLW  = 0xD600;          // UCBRSx = 0xD6, UCBRFx unused, UCOS16 = 0

UCA1CTLW0 &= ~UCSWRST;        // Release from reset
UCA1TXBUF  = 0x4D;            // Example transmit byte





