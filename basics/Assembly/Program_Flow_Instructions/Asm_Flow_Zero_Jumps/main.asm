;---------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-----------------------------------------------------
            .cdecls C, LIST, "msp430.h"                 ; Include device header file
;------------------------------------------------------
            .def    RESET                               ; Export program entry point to make it known to linker
;------------------------------------------------------
            .text                                       ; Assemble into program memory
            .retain                                     ; Override ELF conditional linking
                                                        ; and retain current section
            .retainrefs                                 ; And retain any sections that have
                                                        ; references to current section
;-------------------------------------------------------
RESET       mov.w    #__STACK_END, SP                   ; Initialize stackpointer
StopWDT     mov.w    #WDTPW|WDTHOLD, &WDTCTL            ; Stop watchdog timer


;-------------------------------------------------------
; Main Loop Here
;-------------------------------------------------------
init:
           mov.b     #0, R4

main:  
           mov.b     #15, R5
           cmp       #16, R5                               ; compare tries to calculate if the values are same by subtracting and checking zero flag
           jz        IsEqual                               ; if Z flag = 1
           jnz       IsNotEqual                            ; if Z flag = 0
IsEqual:
           mov.w     #1, R5
           jmp       main                                   ; JUMP TO MAIN TO CONTINUE LOOP

IsNotEqual:
           mov.b      #2, R5
           jmp       m ain                                   ;JUMP TO MAIN TO CONTINUE LOOP

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
