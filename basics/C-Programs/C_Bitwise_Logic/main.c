#include <msp430.h>

int main(void)
{
     WDTCTL = WDTPW | WDTHOLD;     // stop watchdog timer

     int e = 0b11111111110;    // 16 bit number 
     int f = 0x0001;

     while(1)
     {
         e = ~e;          // invert all bits in e
         e = e | BIT7;    // set bits 7 in e, BIT 7 macro is given by header
         e = &  ~BIT0;    // clear bit 0 in e 
         e = e ^ BIT4;    //  toggle bit 4   

         e |= BIT6;       // set bit 6
         e &= ~BIT1;      // clearing  BIT 1

         f = f << 1;      // Rotate Left 1 Time
         f = f << 2;      // Rotate Left 2 Times
         f = f >> 1;      // Rotate Right 1 Time 
     }
}
