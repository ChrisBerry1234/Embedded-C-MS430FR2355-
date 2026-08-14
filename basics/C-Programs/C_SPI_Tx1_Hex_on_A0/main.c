#include <msp430.h>

volatile unsigned int i = 0; 

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;    //stop watchdog timer

    //--Setup SPI_ CLOCK 
    UCA0CTLW0 |= UCSWRST;          // put A0 into SW reset 
    UCA0CTLW0 |= UCSSEL_SMCLK;    // Select SMCLK
    UCA0BRW = 10;                 // Divide 1 MHz -> 100 kHz

    //---setup SPI configuration
    UCA0CTLW0 |= UCSYNC;         // configure to be SPI
    UCA0CTLW0 |= UCMST;          // configure to be SPI master
    //UCMODEx  default configured to 00 (3-pin SPI)

    //------------------configure PORTS
    //----configuring SIMO (P1.7)
    P1SEL1 &= ~BIT7;
    P1SEL0 |= BIT7;

    //--configuring SOMI (P1.6)
    P1SEL1 &= ~BIT6;
    P1SEL0 &= ~BIT6;

    //---configuring SCLK (P1.5)
    P1SEL1 &= ~BIT5;
    P1SEL0 |= BIT5;

    PM5CTL0 &= ~LOCKLMP5;       // Enable digital I/O

    UCA0CTLW0 &= ~UCSWRST;      // Release for operation

    while(1)
    {
      UCATXBUF = 0x4D;
      for (i = 0; i<10000; i=i+1){}
    }
    return 0; 
}
