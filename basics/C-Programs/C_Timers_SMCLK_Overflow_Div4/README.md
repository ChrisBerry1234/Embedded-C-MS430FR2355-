# Toggling LED1 on TB0 Overflow Using SMCLK ÷ 4

This example demonstrates how to toggle **LED1** every time **Timer B0 (TB0)** overflows when clocked with **SMCLK**, using a **divide‑by‑4** configuration to slow down the overflow rate. The timer is configured as a 16‑bit counter in continuous mode, with overflow interrupts enabled.

## Timer Overflow Timing

SMCLK Frequency: **1 MHz**  
Clock Divider: **/4** → Effective Timer Clock = **250 kHz**  
Timer Length: **16 bits** → \( 2^{16} = 65{,}536 \) counts

The overflow period is:



\[
T_{overflow} = \frac{1}{250{,}000} \times 65{,}536 = 262 \text{ ms}
\]



This means LED1 will toggle approximately every **262 milliseconds**.

## TB0 Configuration Summary

- **Clock Source:** SMCLK (`TBxSSEL = 10`)
- **Divider:** `/4` (`ID = 2`)
- **Extended Divider:** `/1` (`IDEX = 000`)
- **Effective Timer Clock:** 250 kHz  
- **Counter Length:** 16‑bit (`CNTL = 00`)
- **Mode:** Continuous (`MC = 10`)
- **Interrupt Enable:** `TBIE = 1`
- **Clear Timer:** `TBCLR = 1`

When the timer reaches its maximum value (`FFFFh`), the **TBIFG** flag is set, triggering the interrupt service routine (ISR). The ISR toggles LED1 and clears the overflow flag.

## Conceptual Behavior

The timer counts upward from 0 to 65535 using the divided SMCLK. Once it overflows:

- TBIFG is set  
- The overflow interrupt fires  
- LED1 toggles  
- TBIFG is cleared  
- The timer continues running  

This creates a periodic LED toggle based on the overflow interval.

## Summary

Using SMCLK with a divide‑by‑4 configuration slows down the overflow rate, making it easier to observe LED toggling without modifying the timer length. This setup is useful for timing tasks that require ~250 ms intervals.

