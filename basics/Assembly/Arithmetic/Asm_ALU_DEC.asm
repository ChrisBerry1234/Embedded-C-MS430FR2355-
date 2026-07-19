;---------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-----------------------------------------------------
            .cdecls C, LIST, "msp430.h"               ; Include device header file
;------------------------------------------------------
            .def    RESET                             ; Export program entry point to make it known to linker
;------------------------------------------------------
            .text                                      ; Assemble into program memory
            .retain                                    ; Override ELF conditional linking
                                                       ; and retain current section
            .retainrefs                                ; And retain any sections that have
                                                       ; references to current section
;-------------------------------------------------------
RESET       mov.w    #__STACK_END, SP                  ; Initialize stackpointer
StopWDT     mov.w    #WDTPW|WDTHOLD, &WDTCTL           ; Stop watchdog timer


;-------------------------------------------------------
; Main Loop Here
;-------------------------------------------------------
main:
           mov.w     #Var1, R4                          ; Initialize the starting address of Var1 into Register R4
           mov.w     #Var2, R5                          ; Initialize the starting address of Var2 into Register R5
           mov.w     #Diff12, R6                        ; Initialize the starting address of memory allocated for the sum into Register R6

           mov.w     0(R4), R7                          ; use indexed addressing to grab the lower 16 bits
           mov.w     0(R5), R8                          ; use indexed addressing to grab the lower 16 bits
           sub.w     R8, R7                             ; R7 = R8 - R7
           mov.w     R7, 0(R6)                          ; move difference into memory(Check status flags, C = 1), Difference = FDDD

           mov.w     2(R4), R7                           ; use indexed addressing to grab the upper 16 bits
           mov.w     2(R5), R8                           ; use indexed addresing to grab the upper 16 bits in 
           subc.w    R8, R7                              ; R7 = R7 - R8
           mov.w     R7, (2)R6                           ; store the difference of the upper of the difference in memory Difference = D353

           jmp       main
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
            .data                                        ; go to data memory @ 2000h
            .retain                                      ; DO NOT OPTIMIZE 

Var1:       .long    0E4651FFFFh
Var2:       .long    11112222h
Diff12:     .space   4


;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
