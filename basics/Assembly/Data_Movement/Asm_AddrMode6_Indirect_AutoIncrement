;-------------------------------------
; Main Loop Here
;-------------------------------------

main: 

          mov.w   #Block1, R4  ; place the initial starting address 2000 into R4
          
          mov.w   @R4+. R5     ; increment to next address in data memory and place that value in R5
          mov.w   @R4+, R6     ; increment to next address in data memory and place that value in R6
          mov.w   @R4+, R7     ; increment to next address in data memory and place that value in R7
          
          ;moving a byte instead of a 16 bit word

          mov.b   @R4+, R8      ; increment to next address in data memory and place LSB value in R8
          mov.b   @R4+, R9      ; increment to next address in data memory and place HSB value in R9
          mov.b   @R4+, R10     ; increment to next address in data memory and place LSB value in R10
          
          jmp     main


;---------------------------------------
; Data Memory Allocation
;----------------------------------------

          .data             ; go to data memory @ 2000h
          .retain           ; DO NOT OPTOMIZE 

Block1:    .short   1122h, 3344h, 7788h,  99AAh    ; create block of constant memory
;----------------------------------------
;Stack Pointer Definition
;----------------------------------------
          .global  __STACK_END
          .sect    .stack
