#include <msp430.h>

//======================================================
// GLOBAL VARIABLES
//======================================================

// First byte = register address
// Following bytes = data
volatile unsigned char Packet[] = {
    0x03,   // Register address
    0x33,   // Data
    0x44,   // Data
    0x55    // Data
};

volatile unsigned int data_counter = 0;
volatile unsigned int i;
volatile unsigned int data_size = sizeof(Packet);


//======================================================
// MAIN
//======================================================

int main(void)
{
    // Stop watchdog timer
    WDTCTL = WDTPW | WDTHOLD;


    //==================================================
    // I2C CONFIGURATION
    //==================================================

    // Put eUSCI_B0 into software reset
    UCB0CTLW0 |= UCSWRST;


    //----- I2C CLOCK ----------------------------------

    // Select SMCLK
    UCB0CTLW0 |= UCSSEL_3;

    // SMCLK / 10 = 100 kHz
    UCB0BRW = 10;


    //----- I2C SYSTEM ---------------------------------

    // I2C mode
    UCB0CTLW0 |= UCMODE_3;

    // Master mode
    UCB0CTLW0 |= UCMST;

    // Transmitter mode
    UCB0CTLW0 |= UCTR;

    // Slave address
    UCB0I2CSA = 0x68;


    //----- I2C DATA TRANSMISSION ----------------------

    // Automatic STOP when byte counter reaches TBCNT
    UCB0CTLW1 |= UCASTP_2;

    // Number of bytes to transmit
    UCB0TBCNT = data_size;


    //==================================================
    // PORT CONFIGURATION
    //==================================================

    // P1.3 = SCL
    P1SEL1 &= ~BIT3;
    P1SEL0 |= BIT3;

    // P1.2 = SDA
    P1SEL1 &= ~BIT2;
    P1SEL0 |= BIT2;

    // Unlock GPIO pins
    PM5CTL0 &= ~LOCKLPM5;


    // Take eUSCI_B0 out of software reset
    UCB0CTLW0 &= ~UCSWRST;


    //==================================================
    // INTERRUPT CONFIGURATION
    //==================================================

    // Enable TX buffer interrupt
    UCB0IE |= UCTXIE0;

    // Enable global interrupts
    __enable_interrupt();


    //==================================================
    // MAIN LOOP
    //==================================================

    while (1)
    {
        // Reset packet position
        data_counter = 0;

        // Generate START condition
        // Hardware will then send:
        // START -> address + write -> ACK
        UCB0CTLW0 |= UCTXSTT;

        // Small delay before starting next transaction
        for (i = 0; i < 100; i++)
        {
        }
    }

    return 0;
}


//======================================================
// INTERRUPT SERVICE ROUTINE
//======================================================

#pragma vector = EUSCI_B0_VECTOR
__interrupt void EUSCI_B0_I2C_ISR(void)
{
    //==================================================
    // CHECK FOR NACK
    //==================================================

    if (UCB0IFG & UCNACKIFG)
    {
        // Slave did not acknowledge

        // Generate STOP condition
        UCB0CTLW0 |= UCTXSTP;

        // Reset packet position so next transaction
        // starts from the beginning
        data_counter = 0;

        // Exit ISR
        return;
    }


    //==================================================
    // TRANSMIT NEXT BYTE
    //==================================================

    UCB0TXBUF = Packet[data_counter];

    data_counter++;


    //==================================================
    // RESET COUNTER AFTER LAST BYTE
    //==================================================

    if (data_counter >= data_size)
    {
        data_counter = 0;
    }
}
