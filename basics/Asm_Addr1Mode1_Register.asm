main:   
      mov.w   PC, R4        ; copy PC into R4
      mov.w   R4, R5        ; copy R4 into R5
      mov.w   R5, R6        ; copy R5 into R6

      mov.b   PC, R7        ; copy LB of PC into R7
      mov.b   R7, R8        ; copy LB of R7 into R8
      mov.b   R8, R9        ; copy LB of R8 into R9

      jmp     main
