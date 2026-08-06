# Toggling LED1 on TB0 Overflow Using ACLK

This example demonstrates how to toggle **LED1** every time **Timer B0 (TB0)** overflows when clocked using **ACLK (32.768 kHz)**. The timer is configured as a 16‑bit counter with no dividers, allowing it to run continuously until it reaches its maximum count and triggers an overflow interrupt.

## Timer Overflow Timing

ACLK Frequency: **32.768 kHz**  
Timer Length: **16 bits** → \( 2^{16} = 65536 \) counts

The overflow period is:



\[
T_{overflow} = \frac{1}{32{,}768} \times 65{,}536 = 2 \text{ seconds}
\]



This means LED1 will toggle every 2 seconds.

## TB0 Configuration Summary

- **Clock Source:** ACLK  
- **Divider:** /1 (default)  
- **Counter Length:** 16‑bit (`CNTL = 00`)  
- **Mode:** Continuous (`MC = 10`)  
- **Interrupt Enable:** `TBIE = 1`  
- **Clear Timer:** `TBCLR = 1`  

When the timer reaches its maximum value, the **TBIFG** flag is set, triggering the interrupt service routine where LED1 is toggled.

## Conceptual Diagram

The timer counts upward from 0 to 65535 using ACLK. Once it overflows, the interrupt fires, LED1 toggles, and the timer continues running.

