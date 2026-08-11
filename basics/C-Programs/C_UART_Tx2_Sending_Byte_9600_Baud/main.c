#include<msp430.h>

volatile unsigned int i;

int main(void)
{

  WDTCTL = WDTPW | WDTHOLD;    // stop watchdog timer
  
  //------setup UART config 
  UCA1CTLW0 |= UCSWRST;       //put UART A1 into SW reset

  UCA1CTLW0 |= UCSSEL__ACLK;  // choose ACLK for clock source
  UCA1BRW = 3;                // set prescalar value to 3 
  UCA1MCTLW = 0x9200;         //set up low-frequency modulation

  //------setup UART Port config 
  P4SEL1 &= ~BIT3;
  P4SEL0 |= BIT3; 

  UCA1CTLW0 &= ~UCSWRST;       // put UART A1 into SW reset
  PM5CTL0 &= ~LOCKLPM5;        // turn on GPIO 

  while(1)
  {
      UCA1TXBUF = 0x55         // trnasmit 0x55 over UART A1 Tx
      for(i = 0; i<10000; i=i+1){} //delay between each transmission
  }
  return 0;
}
