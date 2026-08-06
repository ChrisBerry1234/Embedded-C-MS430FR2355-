# Toggling LED1 on TB0 Overflow Using SMCLK

This example demonstrates how to toggle **LED1** every time **Timer B0 (TB0)** overflows when clocked with **SMCLK at 1 MHz**. The timer is configured as a 16‑bit counter with no dividers, running continuously until it reaches its maximum value and triggers an overflow interrupt.

## Timer Overflow Timing

SMCLK Frequency: **1 MHz**  
Timer Length: **16 bits** → \( 2^{16} = 65{,}536 \) counts

The overflow period is:



\[
T_{overflow} = \frac{1}{1{,}000{,}000} \times 65{,}536 = 65.5 \text{ ms}
\]



This means LED1 will toggle approximately every **65.5 milliseconds**.

## TB0 Configuration Summary

- **Clock Source:** SMCLK (`TBxSEL = 10`)
- **Divider:** /1 (`ID = 00`, `IDEX = 000`)
- **Counter Length:** 16‑bit (`CNTL = 00`)
- **Mode:** Continuous (`MC = 10`)
- **Interrupt Enable:** `TBIE = 1`
- **Clear Timer:** `TBCLR = 1`

When the timer reaches its maximum value (`FFFFh`), the **TBIFG** flag is set, triggering the interrupt service routine (ISR). The ISR toggles LED1 and clears the overflow flag.

## Conceptual Behavior

The timer counts upward from 0 to 65535 using SMCLK. Once it overflows:

- TBIFG is set  
- The overflow interrupt fires  
- LED1 toggles  
- TBIFG is cleared  
- The timer continues running  

This creates a periodic LED toggle based on the overflow interval.

## Summary

This configuration is useful for generating periodic events without manually resetting the timer. Using SMCLK at 1 MHz provides a fast overflow rate, ideal for timing tasks that require sub‑100 ms intervals.

