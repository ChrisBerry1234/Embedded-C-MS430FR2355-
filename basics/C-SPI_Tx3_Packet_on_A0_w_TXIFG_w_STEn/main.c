#include <msp430.h>

volatile char packet[] = {0xF0, 0xF0, 0xA0, 0x40};
volatile unsigned int position;

int main(void)
{
   WDTCTL = WDTPW | WDTHOLD;    //stop watchdog timer

    //--------------CONFIGURE SPI----------------//

    //-----Setup SPI_ CLOCK 
    UCA0CTLW0 |= UCSWRST;          // put A0 into SW reset 
    UCA0CTLW0 |= UCSSEL_SMCLK;    // Select SMCLK
    UCA0BRW = 10;                 // Divide 1 MHz -> 100 kHz

    //-----Setup SPI
    UCA0CTLW0 |= UCSYNC;            //PUT A0 into SPI mode
    UCA0CTLW0 |= UCMST;             //Put A0 into SPI MASTER

    UCA0CTLW0 |= UCMODE1;           // UCMODE = 10 = 4-pin with ACTIVE LOW STE
    UCA0CTLW0 &= ~UCMODE0;

    UCA0CTLW0 |= UCSTEM;            // use STE as normal enable
    

    //--------------Setup Ports--------------------//
    //----Setup Input Ports
    P4DIR &= ~BIT1;                 // make p4.1 an input (SW1)
    P4REN |= BIT1;                  // enable resistor
    P4OUT |= BIT1;                  // make resistor a pull up
    P4IES  |= BIT1;                 // sensitive to H-to-L

   //----------Setup SPI ports
   //---configure SIMO
   P1SEL0 &= ~ BIT7;
   P1SEL1 |= BIT7;

   //--configuring SOMI
   P1SEL0 &= ~ BIT6;
   P1SEL1 |= BIT6;

   //--configuring SCLK 
   P1SEL0 &= ~ BIT5;
   P1SEL1 |= BIT5;

   //-configuring STE 
   P1SEL0 &= ~BIT4;
   P1SEL1 |= BIT4; 

   PM5CTL0 &= ~LOCKLMP5              //turn on D I/O
   UCA0CTLW0 &= ~UCSWRST;           //TAKE OUT OF SW RESET

  //-------------Enable IRQs-----------------//
  //SW 1 (PORT4)
  P4IE |= BIT1;                      // set local P4 enable
  P4IFG &= ~BIT1;                    // clear Interrupt Flag for IRQ

  //Buffer IRQ
  UCA0IE |= UCTXIE;                  // enable A0 Tx IRQ
  UCAIFG &= ~UCTXIFG;                // clear Flag for IRQ

  __enable_interrupt();

    while(1){}
    return 0;
}


//-------------------Interrupt Service Routines ----------------//
#pragma vector = PORT4_VECTOR         // Button press
__interrupt void ISR_PORT4(void)
{
  position = 0;                        // start at position of packet of bits
  UCA0TXBUF = packet[position];        // grab most recent packet of data
  P4IFG &= ~BIT1                       // CLEAR BUTTON FOR NEW INCOMING DATA IRQ
}


#pragma vector = EUSCI_A0_VECTOR      //This IRQ is called when the buffer just sent out data is now empty
__interrupt void ISR_EUSCI_A0(void)
{
  position ++                           //increment to next byte in data packet
  if (position == sizeof(packet)        //branching logic to now if we have reached the end of packet 
  {
      UCA0IFG &= ~UCTXIFG;              //clear flag although buffer is empty to stop data transmission 
  }
  else 
  {
      UCA0TXBUF = packet[position];     //put next byte of data into buffer for transmission, UCTXIFG will be set automatically as data is set out
  }
  //we do not have to worry about clearing flag since TX is cleared and set automatically while TXC is not.
}

  
  
