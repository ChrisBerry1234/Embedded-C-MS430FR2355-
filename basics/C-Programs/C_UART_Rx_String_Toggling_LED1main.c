#include<msp430.h>

volatile unsigned char buffer[16]; //create a buffer with 16 bits allocated for terminal characters
volatile unsigned position = 0; 

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
char rx_buffer[16];
int position = 0;

#pragma vector = EUSCI_A1_VECTOR
__interrupt void RX_ISR(void)
{
    char c = UCA1RXBUF;

    rx_buffer[position] = c;

    if (c == '\0')            // end of string
    {
        if (strcmp(rx_buffer, "RED") == 0) //compared string to desired 
        {
            P1OUT ^= BIT0; //if it is the same toggle LED
        }

        position = 0;         // else just reset for next string
    }
    else
    {
        position++;            // if character is not at end of string, increment position.
    }
}
