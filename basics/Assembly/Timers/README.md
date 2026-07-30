# Timer B0 Overflow LED Toggle (ACLK @ 32.768 kHz)

This example configures **Timer B0 (TB0)** to toggle **LED1** every time the timer overflows while clocked from **ACLK**. The overflow period is determined by the timer clock frequency and the counter size.

---

## Overflow Period Calculation

Using ACLK at **32.768 kHz** with no dividers and a **16‑bit timer**:



\[
T_{\text{overflow}} = (1/f) \times 2^{16}
\]





\[
T_{\text{overflow}} = (1 / 32{,}768\ \text{Hz}) \times 65{,}536 = 2\ \text{seconds}
\]



TB0 overflows every **2 seconds**.

---

## Timer Configuration

- **Clock source:** ACLK  
- **Dividers:** /1 (default)  
- **Counter length:** 16‑bit (default)  
- **Mode:** Continuous (`MC = 10`)  
- **Interrupt:** Enabled (`TBIE = 1`)  

### Register Settings Summary

| Setting | Value | Description |
|--------|-------|-------------|
| `TBxSSEL` | `01` | Select ACLK (32.768 kHz) |
| `ID` | `/1` | Input divider (default) |
| `TBIDEX` | `/1` | Expansion divider (default) |
| `CNTL` | `00` | 16‑bit counter |
| `MC` | `10` | Continuous mode |
| `TBCLR` | `1` | Clear timer |
| `TBIE` | `1` | Enable overflow interrupt |

---

## Timer Overflow Behavior

In continuous mode, the timer counts:

