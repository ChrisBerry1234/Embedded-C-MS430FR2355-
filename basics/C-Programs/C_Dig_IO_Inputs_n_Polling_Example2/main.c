#include <msp430.h>

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD;    // stop watchdog timer
    
  //Setup Ports
  P1DIR |= BIT0;               // Set P1.0 to an output (LED1)
  P1OUT &= ~BIT0;              // Clear LED1

  P4DIR &= ~BIT1;              // Set P4.1 to an input (SW1)
  P4REN |= BIT1;               // P4 Configured as input so we can can configure option pullup/pulldown resistor, in this case we Enable  Pull Up resistor
  P4OUT |= BIT1;               // Sets resistors to pull up 

  PM5CTL0 &= ~ LOCKLPM5;        // Turn on digital I/O of main function loop

  unsigned char SW1 = 0;
  
  while(1)
  {
    SW1 = P4IN; 
    SW1 &= BIT1; 
    
    if (SW1 == 0)
    {
      P1OUT ^= BIT0;             // Toggle  on LED1
    }   
    for(volatile unsigned int i = 0; i<10000; i++)
    {
      //do nothing, is delay loop for polling
    }
  }
}
