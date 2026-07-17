;------------------------------------
; Main Loop Here
;------------------------------------

main: 
          jmp main


;-----------------------------------
; Memory Allocation
;-----------------------------------
          .data               ; go to data memory
          .retain             ; DO NOT OPTIMIZE

Const1:    .short  1234h      ;
Const2:    .short  0CAFEh

Var1:      .space   2
Var2:      .space   2

