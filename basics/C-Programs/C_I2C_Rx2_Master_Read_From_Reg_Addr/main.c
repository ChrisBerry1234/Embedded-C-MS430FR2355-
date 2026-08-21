#include <msp430.h>
//======================================================
// GLOBAL VARIABLES
//======================================================
volatile unsigned char data_read;

//CREATE ENUM FOR DATA TYPE FOR API FUNCTIONS
typedef enum
{
    I2C_RESULT_OK,
    I2C_RESULT_ERROR_TIMEOUT,
    I2C_RESULT_ERROR_TX,
    I2C_RESULT_ERROR_RX,
    I2C_RESULT_ERROR_START
} i2c_result_e;

//APIs DECLARATION
static void i2c_start_tx(void);
static void i2c_start_rx(void);
static i2c_result_e i2c_wait_stop(void);

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

        i2c_start_tx();
        // Wait for STOP to finish before next transaction
        i2c_result_e result = i2c_wait_stop();
        if (result == I2C_RESULT_ERROR_TIMEOUT)
        {
            return 1; 
        }

        i2c_start_rx();
        // Wait for STOP to finish before next transaction
        i2c_result_e result = i2c_wait_stop();
        if (result == I2C_RESULT_ERROR_TIMEOUT)
        {
            return 1; 
        }

        // Small delay between transactions
        __delay_cycles(50000);
    }

    return 0;
}

//-------------APIs-------------------------

static void i2c_start_tx(void)
{
    UCB0CTLW0 |= UCTR;     // Transmitter mode
    UCB0CTLW0 |= UCTXSTT; // PUT INTO START MODE
}

static void i2c_start_rx(void)
{
    UCB0CTLW0 &= ~UCTR;       //receiver mode
    UCB0CTLW0 |= UCTXSTT;    // PUT INTO START MODE AND START TRANSMISSION
     
}

static i2c_result_e i2c_wait_stop(void)
{
    uint16_t retries = RETRY_COUNT;

    //wait until STOP flag is asserted or timeout(AND)
    while(!(UCB0IFG & UCSTPIFG) && 
          !(UCB0STAT & UCNACKIFG) --retries){}
    //TIMEOUT
    if (retries == 0)
    {
        return I2C_RESULT_ERROR_TIMEOUT;
    }

    if ((UCB0STAT & UCNACKIFG))
    {
        return I2C_RESULT_ERROR_RX;
    }

    //CLEAR STOP FLAG
    UCB0IFG &= ~UCSTPIFG;

    return I2C_RESULT_OK;   
}


//-------Interrupt Service Routines
#pragma vector EUSCI_B0_VECTOR
__Interrupt Void EUSCI_B0_I2C_VECTOR(void)
{
    switch(__even_in_range(UCBIV, 0x1E))
        {
            case 0x16:                   // ID 16: RXIFG0
                data_read = UCB0RXBUF;   //Read data from Rx Buffer
                break;

            case 0x18:                   // ID 18: TXIFG0
                UCB0TXBUF = 0x03;        // Send Reg Addr
                break;

            default:
                break;
        }
}
