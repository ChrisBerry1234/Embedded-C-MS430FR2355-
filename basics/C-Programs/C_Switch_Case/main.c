#include <msp430.h>

int main(void)
{
  WDTCT = WDTPW | WDTHOLD;  ; stop watchdog timer

  int i = 0;
  int var_is_ONE = 0;
  int var_is_TWO = 0;  ;compiler will place on SP

  while(1)
  {
    for(i=0; i<5; i=i+1)
    {
      switch(i)
      {
        case 1: var_is_ONE = 1;
                var_is_TWO = 0;
                break;
        
        case 2: var_is_ONE = 0;
                var_is_TWO = 1;

        default: var_is_ONE = 0;
                 var_is_TWO = 0;
                 break;
       }
    }
  }
  
}
