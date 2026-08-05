#include <msp430.h>

int main(void)
{
  WDCTL = WDTPW | WDTHOLD;    ; stop watchdog timer

  int count = 0;  ; optimizer off and compiler puts variable on Stack

  while(1)
  {
    count = count + 1; 
  }
}
