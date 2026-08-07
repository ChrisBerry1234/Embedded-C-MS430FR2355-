# Toggling LED1 Using CCR0 Compare (ACLK)

This example demonstrates how to toggle **LED1** every 0.5 seconds using **Timer B0 (TB0)** in **CCR0 compare mode** with **ACLK at 32.768 kHz**. Instead of relying on timer overflow, this method uses the CCR0 register to generate periodic interrupts at a precise interval.

## Timer Compare Timing

ACLK Frequency: **32.768 kHz**  
Timer Length: **16 bits**  
Desired Toggle Period: **0.5 seconds**

We solve for the number of timer ticks needed:



\[
T_{overflow} = T \times N = 0.5 = \frac{1}{32{,}768} \times N
\]





\[
N = 16{,}384
\]



Thus, setting **TBCCR0 = 16384** produces a 0.5‑second interrupt period.

## TB0 Configuration Summary

- **Clock Source:** ACLK (`TBxSSEL = 01`)
- **Divider:** `/1` (`ID = 00`, `TBIDEX = 000`)
- **Timer Clock:** 32.768 kHz  
- **Mode:** UP mode (`MC = 01`)
- **Counter Length:** 16‑bit (`CNTL = 00`)
- **Compare Register:** `TBCCR0 = 16384`
- **Interrupt Enable:** `CCIE = 1` (CCR0 interrupt)
- **Overflow Interrupt:** Disabled (`TBIE = 0`)
- **Clear Timer:** `TBCLR = 1`

When the timer reaches the value in **TBCCR0**, the **CCR0 interrupt flag** is set, triggering the ISR. The ISR toggles LED1 and clears the flag.

## Conceptual Behavior

The timer counts from 0 up to **TBCCR0**:

- When the counter equals 16384, CCR0 interrupt fires  
- LED1 toggles  
- Timer resets to 0 (UP mode)  
- The cycle repeats every 0.5 seconds  

This method provides precise timing control without relying on full 16‑bit overflow.

## Summary

Using CCR0 compare mode allows fine‑grained timing intervals based on ACLK. This is ideal for periodic tasks such as LED blinking, sensor polling, or low‑power timing operations.

