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
           mov.b     #0, R4                              ; initialize R4 with a value
           
main: 
           mov.b     #-99, R5
           cmp.b     #75, R5                               ; cmp subtracts and asks is -99 is greater than 75, if NO, N flag will not be set, 8 bit complement, result OverFlows, V = 1, C=1 
           jge       ValueIsGreaterThan
           jl        ValueIsLessThan 

ValueIsGreater:
           mov.b     #1, R5
           jmp       main                                  ; JMP MAIN TO CONTINUE LOOP

ValueIsLessThan:
           mov.b     #2, R5
           jmp       main                                   ; JMP MAIN TO CONTINUE LOOP

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
