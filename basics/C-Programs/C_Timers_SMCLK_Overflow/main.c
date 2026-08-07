#include <msp430.h>

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD;  //stop watchdog timer

  //setup ports 
  P1DIR |= BIT0;          //P1.0 to an output
  P1OUT &= ~BIT0;        //set P1.0 LED off

  P6DIR |= BIT0;           //Enable P6 as an Output
  P6OUT |= BIT0;           //Turning LED On 

  PM5CTL0 &= ~LOCKLPM5;    //enable digital I/O

  //-Setup Timer
  TB0CTL |= TBCLR;          // clear TB0 timer
  TB0CTL |= TBSSEL__SMCLK;  // choose SMCLK as main clock source
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
  P6OUT ^= BIT0; //TOGGLE LED OFF
  
  TBOCTL &= ~TBIFG;
}
}
