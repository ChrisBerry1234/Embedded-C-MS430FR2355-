12‑Bit Timer B0 Overflow (ACLK @ 32.768 kHz)
This module demonstrates how to configure Timer B0 (TB0) to toggle LED1 every time the timer overflows while clocked from ACLK.
To increase the overflow rate, the timer is configured in 12‑bit mode instead of the default 16‑bit mode.

⏱️ Overflow Period Calculation
ACLK frequency: 32.768 kHz  
Timer size: 12 bits → counts from 0 to 4095

𝑇
overflow
=
(
1
/
𝑓
)
⋅
2
12
𝑇
overflow
=
(
1
/
32,768
 Hz
)
⋅
4096
=
125
 ms
Overflow rate: ~8 times per second

⚙️ Timer Configuration Summary
Component	Setting	Meaning
Clock Source	TBxSSEL = 01	ACLK (32.768 kHz)
Input Divider	ID = 00	/1
Expansion Divider	TBIDEX = 00	/1
Counter Length	CNTL = 01	12‑bit
Mode	MC = 10	Continuous
Clear Timer	TBCLR = 1	Reset counter
Interrupt Enable	TBIE = 1	Enable overflow interrupt


These settings produce a 12‑bit continuous counter clocked directly from ACLK.

🔁 Timer Overflow Behavior
In 12‑bit continuous mode, TB0 increments:

Code
0000h → 00FEh → 0FFEh → FFFEh → FFFFh → overflow → 0000h
Each overflow sets:

TBIFG = 1 (Timer B interrupt flag)

Inside the ISR:

Clear TBIFG manually

Toggle LED1

📌 Notes
TBIFG must be cleared inside the ISR — MSP430 does not clear it automatically.

GIE is automatically cleared on ISR entry, preventing nested interrupts unless manually re‑enabled.
