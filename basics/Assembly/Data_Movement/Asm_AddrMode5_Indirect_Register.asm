;-----------------------------
; Main Loop Here
;-----------------------------

main:

        mov.w   #2000h, R4   ; put 2000h into R4 to act as a pointer(immediate addressing)
        mov.w   @R4, R5      ; put contents of R4 into R5

        mov.w   #Const2, R6  ; put 2002h into R6 to act as a pointer to data memory
        mov.w   @R6, R7      ; put contents of address held in R6 into R7

        jmp      main



;---------------------------
; Data Memory Allocation
;---------------------------

         .data             ; go to program memory @2000h
         .retain           ; DO NOT OPTIMIZE

Const1:  .short    0DEADh  ; put DEADh into address 2000h
Const2:  .short    0BEEFh  ; put BEEFh into address 2002h

