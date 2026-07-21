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
main:
           mov.b     #0, R4
           
main: 
           mov.b     #-1, R5
           tst       R5                                   ; tst subtracts from zero to determine whether or not a value is negative or not
           jn        ValueIsNegative
           jmp       ValueIsNotNegative

ValueIsNegative:
           mov.b     #1, R5
           jmp       main                                  ; JMP MAIN TO CONTINUE LOOP

ValueIsNotNegative:
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
