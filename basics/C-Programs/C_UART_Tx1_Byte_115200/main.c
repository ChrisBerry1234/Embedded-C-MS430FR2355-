#include <msp430.h>

volatile unsigned int i; 

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD; //stop watchdog timer

  //--setup UART
  UCA1CTLW0 |= UCSWRST;     //put UART A1 into SW reset 

  UCA1CTLW0 |= UCSSEL_SMCLK; //choosing SMCLK for UART A1
  UCA1BRW = 8;               //setting prescalar value
  UCA1MCTLW = 0xD600;       //configure modulation settings + low frequency

  P4SEL1 &= ~BIT3;           //P4SEL.3 : P4SEL0.3 = 01
  P4SEL0 |= BIT3;            //puts UART A1 Tx on P4.3

  UCA1CTLW0 &= ~UCSWRST;     //take UART A1 out of Software Reset

  //-------- main loop 

  while(1)
  {
    UCA1TXBUF = 0x4D;        // repeatedly send x4D out of UART A1
    for(i = 0; i < 10000; i=i+1){} //delay between frames
  }

  return 0;
}
