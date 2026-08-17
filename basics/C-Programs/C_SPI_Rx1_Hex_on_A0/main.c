#include <msp430.h>

volatile char packet[] = {0xF0, 0xF0, 0xA0, 0x40};
volatile char dummybyte = 0x10;
volatile unsigned dummybyte_sent = 0;
volatile unsigned dummybyte_received = 0;
volatile unsigned int position;
volatile unsigned int ReceiveVal;

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;    // stop watchdog timer

    //--------------CONFIGURE SPI----------------//

    //-----Setup SPI CLOCK
    UCA0CTLW0 |= UCSWRST;          // put A0 into SW reset
    UCA0CTLW0 |= UCSSEL__SMCLK;    // Select SMCLK
    UCA0BRW = 10;                  // Divide 1 MHz -> 100 kHz

    //-----Setup SPI
    UCA0CTLW0 |= UCSYNC;           // PUT A0 into SPI mode
    UCA0CTLW0 |= UCMST;             // Put A0 into SPI MASTER


    //--------------Setup Ports--------------------//

    //---Setup Output Ports
    P1DIR |= BIT0;                  // set P1.0 (LED1) to output
    P1OUT &= ~BIT0;                 // LED1 is off initially

    P6DIR |= BIT6;                  // set P6.6 (LED2) to output
    P6OUT &= ~BIT6;                 // LED2 is off initially


    //----Setup Input Ports

    // SW1 - P4.1
    P4DIR &= ~BIT1;                 // make P4.1 an input (SW1)
    P4REN |= BIT1;                  // enable resistor
    P4OUT |= BIT1;                  // make resistor a pull up
    P4IES |= BIT1;                  // sensitive to H-to-L


    // SW2 - P2.3
    P2DIR &= ~BIT3;                 // make P2.3 an input (SW2)
    P2REN |= BIT3;                  // enable resistor
    P2OUT |= BIT3;                  // make resistor a pull up
    P2IES |= BIT3;                  // sensitive to H-to-L


    //----------Setup SPI ports------------//

    //---configure SIMO
    P1SEL0 &= ~BIT7;
    P1SEL1 |= BIT7;

    //--configuring SOMI
    P1SEL0 &= ~BIT6;
    P1SEL1 |= BIT6;

    //--configuring SCLK
    P1SEL0 &= ~BIT5;
    P1SEL1 |= BIT5;


    PM5CTL0 &= ~LOCKLPM5;           // turn on D I/O
    UCA0CTLW0 &= ~UCSWRST;          // TAKE OUT OF SW RESET


    //-------------Enable IRQs-----------------//

    // SW 1 (PORT4)
    P4IE |= BIT1;                   // set local P4 enable
    P4IFG &= ~BIT1;                 // clear Interrupt Flag for IRQ


    // SW 2 (PORT2)
    P2IE |= BIT3;                   // set local P2 enable
    P2IFG &= ~BIT3;                 // clear interrupt flag for IRQ


    // RX interrupt
    UCA0IE |= UCRXIE;               // enable A0 RX IRQ
    UCA0IFG &= ~UCRXIFG;             // clear flag for IRQ


    __enable_interrupt();


    //-------------Main Loop-----------------

    while(1)
    {
    }

    return 0;
}


//------Interrupt Service Routines------------------//

#pragma vector = PORT4_VECTOR     // ISR for S1
__interrupt void ISR_Port4_S1(void)
{
    // when switch is pressed, this ISR will run
    // send dummy byte to generate clock

    UCA0TXBUF = dummybyte;            // Master sends dummy byte
    dummybyte_sent = 1;

    P4IFG &= ~BIT1;                   // clear ISR flag
}


#pragma vector = PORT2_VECTOR     // ISR for S2
__interrupt void ISR_Port2_S2(void)
{
    position = 0;

    if (dummybyte_sent == 1 && dummybyte_received == 1)
    {
        // check if transmit buffer is empty before sending packets of data
        if (UCA0IFG & UCTXIFG)        // TX buffer is ready
        {
            UCA0TXBUF = packet[position];
        }
    }

    P2IFG &= ~BIT3;                   // Clear SW2 flag
}


#pragma vector = EUSCI_A0_VECTOR
__interrupt void ISR_EUSCI_A0(void)
{
    if (UCA0IFG & UCRXIFG)
    {
        ReceiveVal = UCA0RXBUF;

        if (ReceiveVal == dummybyte)
        {
            dummybyte_received = 1;

            P1OUT ^= BIT0;
        }

        else
        {
            // increment position
            position++;

            // check if we are at end of packet of data
            if (position < sizeof(packet))
            {
                UCA0TXBUF = packet[position];

                P6OUT ^= BIT6;
            }
        }
    }
}
