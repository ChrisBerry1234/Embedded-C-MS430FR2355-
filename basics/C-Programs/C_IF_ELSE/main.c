#include <msp430.h>

int main(void)
{
  WDCTL = WDTPW | WDTHOLD;

  int i = 0;
  int var_is_two = 0;

  while(1)
  {
    for(i=0; i<5; i=i+1)
      {
        if(i == 2)
        {
          var_is_two = 1;
        }

        else
        {
          var_is_two = 0;
        }
      }
  }
}
