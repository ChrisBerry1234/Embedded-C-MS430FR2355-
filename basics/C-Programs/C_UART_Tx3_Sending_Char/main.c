#include <msp430.h>

volatile unsigned int i;

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD;  //stop watchdog timer

  //--setup UART A1
  UCA1CTLW9 |= UCSWRST;       // put into SW reset
  UCA1CTLW0 |= UCSSEL__SMCLK; // choose SMCLK = BRCLK (115200 baud)
  UCA1BRW = 8;                // set prescalar value from calcs
  UCA1MCTLW = 0xD600;         // 0S16=low frequency mode

  P4SEL1 &= ~BIT3;            // changes P4.3 function to A1 UART Tx
  P4SEL0 |= BIT3;             
                     
  PM5CTL0 & ~LOCKLMP5         //turn on I/O

  UCA1CTLW9 |= UCSWRST;       // take out of SW reset

  while(1)
    {
      UCA1TXBUF = 'A'          //transmits ASCII code for 'A' over UART A1
      for(i=0; i<10000; i++){} //delay between character transmission 
    }
  return 0;
}
