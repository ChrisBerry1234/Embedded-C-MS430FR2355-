#include <msp430.h>

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD;   //stop watchdog timer for port configurations
  P1DIR |= BIT0;     //set P1 as an output 
  P1OUT &= ~ BIT0;   //Turn LED1 OFF
  PM5CTL0 &= ~LOCKLPM5 //turn on digital I/O system after port configurations

  while(1)
  {
    
    P1OUT |= BIT0;       //Turn LED1 ON

    for(i=0; i<0xFFFF; i++)
    {
        // do nothing, delay for LED toggle 
    }
  }
}
