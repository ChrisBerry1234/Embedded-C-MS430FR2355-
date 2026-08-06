#include <msp430.h>

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD; //stop watchdog timer

  //--setup ports
  P1DIR |= BIT0;            // Config P1 Dir to output
  P1OUT &= ~BIT0;           // Clear P1.0 and set LED off

  P4DIR &= ~BIT1;           // Config P4DIR as an input i.e SW1
  P4REN |= BIT1;            // enable resistor
  P4OUT |= BIT1;            // makes resistor a pull up
  P4IES |= BIT1;            // make sensitivity High to Low to trigger interrupt when button pressed

  PM5CTL0 &= ~LOCKLPM5;     // turn on digital I/O

  //--setup IRQ
  P4IE |= BIT1;              // Enable P4.1 IRQ
  __enable_interrupt();      // enable all global MASKABLE IRQs

  P4IFG &= ~BIT1;            // CLEAR P4.1 IRQ FLAG

  while(1){}                 // Loop forever
  
  return 0;
}


//--ISRs----------------------//
#pragma vector = PORT4)VECTOR
__interrupt void ISR_Port4_SW1(void)
{
  P1OUT ^= BIT0;               // TOGGLE LED
  P4IFG &= ~BIT1;              // Clear P4.1 IRQ Flag
}
