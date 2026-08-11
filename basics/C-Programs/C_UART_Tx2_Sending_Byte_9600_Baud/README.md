# Serial Communication — UART @ 9600 Baud (ACLK = 32.768 kHz)

Configure the MSP430 eUSCI_A1 peripheral as a UART and transmit the value **0x55** at **9600 baud**. The UART uses standard framing: **8-bit, LSB first, no parity, 1 stop bit**. The transmit output for eUSCI_A1 is on **P4.3**. The BRCLK source is **ACLK = 32.768 kHz**.

---

## Baud Rate Calculation (Low-Frequency Mode)



\[
N = \frac{32{,}768}{9{,}600} \approx 3.41
\]



### Integer Divider


\[
UCBRx = 3
\]



Stored in:

UCA1BRW = 3


### Fractional Portion


\[
\text{fraction} = 0.41
\]



Low-frequency mode → **UCBRFx unused**, only **UCBRSx** used.

### Modulation
TI table:

UCBRSx = 0x92


Modulation register:
UCA1MCTLW = 0x9200



Breakdown:
- UCBRSx = 0x92  
- UCBRFx = 0  
- UCOS16 = 0  

---

## Final Register Configuration

```c
UCA1CTLW0 |= UCSWRST;        // Hold eUSCI in reset
UCA1CTLW0 |= UCSSEL__ACLK;   // Select ACLK

UCA1BRW   = 3;               // Divider
UCA1MCTLW = 0x9200;          // Modulation

P4SEL1 &= ~(BIT3);           // Configure P4.3 as TX
P4SEL0 |=  (BIT3);

UCA1CTLW0 &= ~UCSWRST;       // Release reset

UCA1TXBUF = 0x55;            // Transmit byte

