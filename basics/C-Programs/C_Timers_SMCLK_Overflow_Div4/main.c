#include <msp430.h>

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD;  //stop watchdog timer

  //setup ports 
  P1DIR |= BIT0;            //P1.0 to an output
  P1OUT &= ~BIT0;           //set P1.0 LED off 

  PM5CTL0 &= ~LOCKLPM5;     //enable digital I/O

  //-Setup Timer
  TB0CTL |= TBCLR;          // clear TB0 timer
  TB0CTL |= TBSSEL__SMCLK;  // choose SMCLK as main clock source(32.768Hz)
  TB0CTL |= ID_4;           // divide main clock by 4 to get 250kHz
  TB0CTL |= MC__CONTINUOUS; // Put timer into continous mode

  //setup timer IRQ
  TB0CTL |= TBIE;           // set local enable for interrupts
  __enable_interrupt();     // enable all maskable IRQs
  TB0CTL &= ~ TBIFG;        // clear interrupt flag for interrupt assert

  //Main Loop
  while(1)
  {};
  

  return 0;
}

//---------ISRs---------------//
#pragma vector = TIMER0_B1_VECTOR 
#interrupt void ISR_TB0_Overflow(void)
{
  P1OUT ^= BIT0; //TOGGLE LED ON  
  TBOCTL &= ~TBIFG;
}
}
