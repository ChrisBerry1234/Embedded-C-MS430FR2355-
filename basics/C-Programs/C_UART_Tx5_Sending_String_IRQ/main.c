#include <mso430.h>

//Global Variables
volatile unsigned position = 0;
volatile char[] message = "Hello World  ";

int main(void)
{
  WDTCTL = WDTPW | WDTHOLD;    // stop watchdog timer

  //-----setup UART A1
  UCA1CTLW0 |= UCSWRST;        // puts UART A1 into SW reset

  UCA1CTLW0 |= UCSSEL__SMCLK;  // BRCLK = SMCLK --> 115200 baud
  UCA1BRW = 8;                 // prescalar = 8
  UCA1MCTLW = 0xD600;          // sets to low-freq mode
  
  //--- configure ports
  P4DIR &= ~BIT1;               // Make P4.1 an input
  P4REN |= BIT1;                // enable resistor 
  P4OUT |= BIT1;                // enable pull up resistor
  P4IES |= BIT1;                // make IRQ sens H-to-L 
  
  P4SEL1 &= ~ BIT3;             // Set P4.3 to use UART A1 Tx function
  P4SEL0 |= BIT3;

  PM5CTL0 &= ~LOCKLPM5;         // turn on digital I/O
  
  UCA1CTLW0 |= UCSWRST;         // puts UART A1 out of SW reset

  //ENABLE IRQs
  P4IE |= BIT1;                  // enables SW1 IRQ
  __enable_interrupt();          // enable all global maskable interrupts
  P4IFG &= ~BIT0;                // clears flag.

  while(1){}

  return 0;
}


//-------------------Interrupt Service Routine
#pragma vector = PORT4_VECTOR
__interrupt void ISR_Port4_S1(void)
{
    position = 0;                     // start at beginning of string
    UCA1IE |= UCTXCPTIE;              // enable Tx complete interrupt
    UCA1IFG &= ~UCTXCPTIFG;           // clear Tx complete flag
    UCA1TXBUF = message[position];    // send first character

    P4IFG &= ~BIT0;                   // clear button interrupt flag
}

#pragma vector = EUSCI_A1_VECTOR
__interrupt void ISR_EUSCI_A1(void)
{
    // Check if we've reached the end of the string
    if (message[position] == '\0')
    {
        UCA1IE &= ~UCTXCPTIE;         // disable Tx complete interrupt
        UCA1IFG &= ~UCTXCPTIFG;       // clear flag
        position = 0;                 // reset for next button press
    }
    else
    {
        position++;                   // move to next character
        UCA1TXBUF = message[position]; // transmit next character
    }

    UCA1IFG &= ~UCTXCPTIFG;           // clear interrupt flag
}
