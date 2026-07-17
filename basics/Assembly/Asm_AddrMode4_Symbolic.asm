;------------------------------------
; Main Loop Here
;------------------------------------

main: 
          mov.w    Const1, R4  ; copy contents of Const1 into Register R4
          mov.w    R4, Var1    ; copy all contents of R4 into Var1

          mov.w    Const2, R5  ; copy contents of Const2 into Register R5
          mov.w    R5, Var2    ; copy all contents of R5 into Var2

          jmp      main


;-----------------------------------
; Memory Allocation
;-----------------------------------
          .data               ; go to data memory
          .retain             ; DO NOT OPTIMIZE

Const1:   .short    1234h       ; 1234h @2000h
Const2:   .short    0CAFEh      ; 0CAFEh @2002h

Var1:     .space     2          ; reserve 2 bytes @ 2004h 
Var2:     .space     2          ; reserve 2 bytes @ 2006h

