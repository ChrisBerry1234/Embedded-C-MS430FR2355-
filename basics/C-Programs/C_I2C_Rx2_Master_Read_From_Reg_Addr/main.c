#include <msp430.h>

//======================================================
// GLOBAL VARIABLES
//======================================================
volatile unsigned char data_read;

#define RETRY_COUNT 50000
#define DATA_SIZE   1

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
static void         i2c_start_tx(void);
static void         i2c_start_rx(void);
static i2c_result_e i2c_wait_stop(void);

//======================================================
// MAIN
//======================================================

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;

    UCB0CTLW0 |= UCSWRST;

    UCB0CTLW0 |= UCSSEL_3;   // SMCLK
    UCB0BRW    = 10;         // 100 kHz

    UCB0CTLW0 |= UCMODE_3;   // I2C
    UCB0CTLW0 |= UCMST;      // Master
    UCB0I2CSA  = 0x68;       // Slave addr

    UCB0CTLW1 |= UCASTP_2;   // Auto STOP
    UCB0TBCNT  = DATA_SIZE;

    P1SEL1 &= ~BIT3;
    P1SEL0 |=  BIT3;         // SCL

    P1SEL1 &= ~BIT2;
    P1SEL0 |=  BIT2;         // SDA

    PM5CTL0 &= ~LOCKLPM5;

    UCB0CTLW0 &= ~UCSWRST;

    UCB0IE |= UCTXIE0 | UCRXIE0;
    __enable_interrupt();

    while (1)
    {
        i2c_start_tx();
        i2c_result_e result = i2c_wait_stop();
        if (result == I2C_RESULT_ERROR_TIMEOUT || result == I2C_RESULT_ERROR_RX)
            return 1;

        i2c_start_rx();
        result = i2c_wait_stop();
        if (result == I2C_RESULT_ERROR_TIMEOUT || result == I2C_RESULT_ERROR_RX)
            return 1;

        __delay_cycles(50000);
    }

    return 0;
}

//-------------APIs-------------------------

static void i2c_start_tx(void)
{
    UCB0CTLW0 |= UCTR;      // TX mode
    UCB0CTLW0 |= UCTXSTT;   // START
}

static void i2c_start_rx(void)
{
    UCB0CTLW0 &= ~UCTR;     // RX mode
    UCB0CTLW0 |= UCTXSTT;   // START
}

static i2c_result_e i2c_wait_stop(void)
{
    uint16_t retries = RETRY_COUNT;

    while ((UCB0CTLW0 & UCTXSTP) && !(UCB0IFG & UCNACKIFG) && --retries)
    {
    }

    if (retries == 0)
        return I2C_RESULT_ERROR_TIMEOUT;

    if (UCB0IFG & UCNACKIFG)
        return I2C_RESULT_ERROR_RX;

    return I2C_RESULT_OK;
}

//-------Interrupt Service Routine-----------
#pragma vector = EUSCI_B0_VECTOR
__interrupt void EUSCI_B0_I2C_ISR(void)
{
    switch (__even_in_range(UCB0IV, 0x1E))
    {
        case 0x14:                   // RXIFG0
            data_read = UCB0RXBUF;
            break;

        case 0x16:                   // TXIFG0
            UCB0TXBUF = 0x03;        // example: send reg addr
            break;

        default:
            break;
    }
}
