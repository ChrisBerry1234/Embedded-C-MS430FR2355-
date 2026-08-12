# UART Receive Example — Toggle LED on Character ('r')

This example configures **eUSCI_A1** on the MSP430 to receive UART data at **115200 baud** using **SMCLK = 1 MHz**.  
Whenever the character **'r'** is received, the program toggles **LED1**.  
Reception is handled using the **UCRXIFG** interrupt.

---

## UART Configuration

- **Module:** eUSCI_A1  
- **Baud Rate:** 115200  
- **Clock Source:** SMCLK = 1 MHz  
- **Divider:** `UCA1BRW = 8`  
- **Modulation:** `UCA1MCTLW = 0xD600`  
- **RX Pin:** P4.2 (UCA1RXD)  
  - `P4SEL1 &= ~(BIT2);`  
  - `P4SEL0 |=  (BIT2);`

---

## Interrupt Used

- **UCRXIFG** — asserts when a full UART frame has been received  
- The ISR reads `UCA1RXBUF` and checks if the received byte is `'r'`.

---

## Basic Flow

1. Configure UART for 115200 baud.  
2. Enable RX interrupt (`UCRXIE`).  
3. When a byte arrives, `UCRXIFG` triggers the ISR.  
4. Read the received character from `UCA1RXBUF`.  
5. If the character is `'r'`, toggle LED1.  
6. Clear the RX flag to allow the next interrupt.

---

## Example ISR

```c
#pragma vector = EUSCI_A1_VECTOR
__interrupt void ISR_EUSCI_A1(void)
{
    if (UCA1RXBUF == 'r')
        P1OUT ^= BIT0;          // toggle LED1

    UCA1IFG &= ~UCRXIFG;        // clear RX flag
}
