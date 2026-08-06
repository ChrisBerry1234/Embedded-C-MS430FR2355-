#include <msp430.h>

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD    // stop watchdog timer
    
  //Setup Ports
  P1DIR |= BIT0;               // Set P1.0 to an output (LED1)
  P1OUT &= ~BIT0;              // Clear LED1

  P4DIR &= ~BIT0;              // Set P4.1 to an input (SW1)
  P4REF |= BIT1;               // P4 Configured as input so we can can configure option pullup/pulldown resistor, in this case we Enable  Pull Up resistor
  P4OUT |= BIT1;               // Sets resistors to pull up 

  PM5CTL0 &= ~ LOCKLPM5        // Turn on digital I/O of main function loop

  while(1)
  {
   
    while(( BIT1 & P4IN) != 0);  // wait for button press

    P1OUT ^= BIT1;

    while ((P4IN & BIT1) == 0);   // Wait for release
  }
}
