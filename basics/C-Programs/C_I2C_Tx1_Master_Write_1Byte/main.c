#include <msp430.h>

volatile unsigned int i;

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD;     //stop watchdog timer

  //----------setup B0 for I2C
  UCB0CTLW0 |= UCSWRST;        // PUT INTO SW RST

  //Setup I2C Clock
  UCB0CTLW0 |= UCSSEL_3;       // choose SMCLK
  UCB0BRW = 10;                // set prescalar to 10 => SCK = 100KHZ

  //Setup I2C System
  UCB0CTLW0 |= UCMODE_3;       // configure I2C mode
  UCB0CTLW0 |= UCMST;          // configure as master for transmission
  UCB0CTLW0 |= UCTR;           // configure for transmitting data
  I2CSA = 0x68;                // slave addressing we will be transmitting data to.
  
  //Setup handle for I2C data transmission
  UCB0CTLW1 |= UCASTP_2;       // auto STOP mode generated when byte counter reaches value stored inUCBxTBCNT
  UCB0TBCNT = 1;              // Count = 1 byte

  //--------Setup Ports

  //--setup SCL
  P1SEL1 &= ~BIT3;
  P1SEL0 |= BIT3;

  //--setup SDA
  P1SEL1 &= ~BIT2;
  P1SEL0 |= BIT2;

  PM5CTL0 &= ~LOCKLPM5;   

  UCB0CTLW0 &= ~UCSWRST;        // TAKE OUT OF SW RST

  //-----enable B0 TX0 IRQ
  UCB0IE |= UCTXIE0            //local interrupt
  _enable_interrupt();
  

  while(1)
    {
      UCB0CTLW0 |= UCTXSTT;    //manually start message (START)
      for(i = 0; i<100; i = i+1){} //delay 
      
    }

  return 0;
 }
//------------------ISRs-----------//
#pragma vector = EUSCI_B0_VECTOR
__interrupt void EUSCI_B0_I2C_ISR(void)
{
  UCB0TXBUF = 0xBB;             //sends data once TX buffer is empty after sending out first few bytes within data frame
}
