#include<msp430.h>

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD;    //stop watchdog timer

  //------setup  UARTA1
  UCA1TCLW0 |= UCSWRST;        // put A1 into SW reset
  UCA1CTWLW0 |= UCSSEL__SMCLK; // BRCLK = SMCLK 
  UCA1BRW = 8;                 // set Prescalar value
  UCA1MCTLW = 0xD600;          //set to low frequency mode

  //------setup ports UART
  P4SEL1 &= ~BIT2               // P4.2 set function to UART A1 Rx(01)
  P4SEL0 |= BIT2;

  //------setup output LED ports
  P1DIR |= BIT0;                // set P1.0 to output (LED1)
  P1OUT &= ~BIT0;               // initial state of LED1 is off

  PM5CTL0 &= ~LOCKLPM5;         // turn on GPIO

  UCA1TCLW0 &= ~UCSWRST;         // put A1 into SW reset

  //-----Setup IRQ A1
  UCA1IE |= UCRXIE;              // enable local enable for A1 RXIFG, unlike transmit, we do not configure a event to transmit/receive
  __enable_interrupt();
  //Interrupt Flags sets and clears automatically for Rx Buffer since we cannot trigger a flag manually

  //---main loop
  while(1){}
  return 0; 
  

}

//---------------Interrupt Service Routines (ISRs)
#pragma vector = EUSCI_A1_VECTOR
__interrupt void RX_ISR(void)
{
  //check for a specific character 
  if (UCA1RXBUF == 't')
  {
    P1OUT ^= BIT0;                //toggle LED1
  }
}
