#include <msp430.h>
//======================================================
// GLOBAL VARIABLES
//======================================================
volatile unsigned char data_read;

//CREATE ENUM FOR DATA TYPE FOR FUNCTIONS
typedef enum
{
    I2C_RESULT_OK,
    I2C_RESULT_ERROR_TIMEOUT,
    I2C_RESULT_ERROR_TX,
    I2C_RESULT_ERROR_RX,
    I2C_RESULT_ERROR_START
} i2c_result_e;

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
    P1SEL0 |=  BIT3;

    // P1.2 = SDA
    P1SEL1 &= ~BIT2;
    P1SEL0 |=  BIT2;

    // Unlock GPIO pins
    PM5CTL0 &= ~LOCKLPM5;


    // Take eUSCI_B0 out of software reset
    UCB0CTLW0 &= ~UCSWRST;


    //==================================================
    // INTERRUPT CONFIGURATION
    //==================================================

    // Enable TX buffer interrupt + NACK interrupt
    UCB0IE |= UCTXIE0 | UCRXIE0;

    // Enable global interrupts
    __enable_interrupt();


    //==================================================
    // MAIN LOOP
    //==================================================

    while (1)
    {
        //---Transmit Register Address with WRITE message
        UCB
        //---Receive Data from Slave with a READ Message 
      

        // Generate START condition
        // Hardware will then send:
        // START -> address + write -> ACK
        UCB0CTLW0 |= UCTXSTT;

        // Wait for STOP to finish before next transaction
        while (UCB0CTLW0 & UCTXSTP);

        // Small delay between transactions
        __delay_cycles(50000);
    }

    return 0;
}
}
