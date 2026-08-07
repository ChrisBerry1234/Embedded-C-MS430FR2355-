#include <msp430.h>

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD; //stop watchdog timer

  //--setup ports 
  P1DIR |= BIT0;            // set P1.0 to output LED1)
  P1OUT |= BIT0;            // set LED1=1 initially
  PM5CTL0 &= ~LOCKLPM5;     // turn on digital I/O

  //---------setup timer TB0
  TB0CTL |= TBCLR;         // reset TB0
  TB0CTL |= MC__UP;         // put into UP mode for CCR0
  TB0CTL |= TBSSEL__ACLK;   // choose ACLK (32KHz)

  //--setup compares
  TB0CCR0 = 32767           // set PWM period
  TB0CCR1 = 1638;            // set PWM duty cycle
    
  //--configure all interrupts for compares
  TB0CCTL0 |= CCIE;
  TB0CCTL1 |= CCIE;
  __enable__interrupt();

  TB0CCTL0 &= ~CCIFG;
  TB0CCTL1 &= ~CCIFG;

  //-- main loop
  while(1){};

  return 0;  
}

\\--------- Interrupt Service Routines ---------//
#pragma vector = TIMER0_B0_VECTOR // ISR for period
__interrupt void ISR_TB0_CCR0(void)
{
  P1OUT |= BIT0;       // set LED1 ON
  TB0CCTL0 &= ~CCIFG;  //clear interrupt flag for next assertion otherwise ISR will continue to run
}

#pragma vector = TIMER0_B1_VECTOR //ISR for duty cycle
__interrupt void ISR_TB0_CCR1(void)
{
    switch (TB0IV)
    {
        case TB0IV_TBCCR1:
            // CCR1 compare interrupt
            P1OUT &= ~BIT0;      //turn LEDOFF
            //clear interrupt flag for next assertion(automatic)
            break;

        case TB0IV_TBIFG:
            // Timer overflow interrupt
            break;

        default:
            break;
    }
}
}
