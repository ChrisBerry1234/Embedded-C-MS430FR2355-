#include <msp430.h>

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD;  //stop watchdog timer

  //setup ports 
  P1DIR |= BIT0;          //P1.0 to an output
  P1OUT &= ~BIT0;        //set P1.0 LED off 

  PM5CTL0 &= ~LOCKLPM5;    //enable digital I/O

  //-Setup Timer
  TB0CTL |= TBCLR;          // clear TB0 timer
  TB0CTL |= MC__UP         // Put timer into  UP MODE FOR COMPARE
  TB0CTL |= TBSSEL__ACLK;  // choose ACLK as main clock source
  TB0CCR0 = 16384          //INSERT N VALUE FOR TIMER COMPARE REGISTER
  

  //setup timer IRQ
  TB0CCTL0 |= CCIE;           // set local enable for interrupts
  __enable_interrupt();     // enable all maskable IRQs
  TB0CCTL &= ~CCIFG;        // clear interrupt flag for interrupt assert

  //Main Loop
  while(1)
  {};
  

  return 0;
}

//---------ISRs---------------//
#pragma vector = TIMER0_B0_VECTOR 
#interrupt void ISR_TB0_Overflow(void)
{
  P1OUT ^= BIT0; //TOGGLE LED ON  
  TBOCCTL &= ~CCIFG;
}
}
