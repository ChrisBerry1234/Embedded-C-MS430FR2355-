#include <msp430.h>

volatile char message[] = "Hello World"; // message 
volatile unsigned int position = 0;     // position of each character in the string
volatile unsigned i = 0;                // variable for delay for characters
volatile unsigned j = 0;                // variable for delay between each string

int main(void)
{
  
  WDTCTL = WDTPW | WDTHOLD;   //stop watchdog timer

  //----setup UART A1 (Tx)
  UCA1CTLW0 |= UCSWRST;       // put UART A1 into SW Reset
  UCA1CTLW0 |= USSEL_SMCLK;    // select SMCLK (faster clock speeds) (1MHZ) --> 115200 baud
  UCA1BRW = 8;                // set prescalar value for baud rate
  UCA1MCTLW = 0xD6;           // setup modulation

  P4SEL1 &= ~BIT3;
  P4SEL0 |= BIT3;

  PM5CTL0 &= ~LOCKLPM5;       // turning on digital I/O
  UCA1CTLW0 &= ~UCSWRST;       // put UART A1 into SW Reset
  

  while(1)
  {
    for (position = 0; message[position] != '\0'; position ++)
    {
       UCA1TXBUF = message[position];
       for(i = 0; i<100; i++){}          //delay between characters
    }
  for ( j=0; j<10000' j++){}            //delay between strings 
  }
  return 0;
}
