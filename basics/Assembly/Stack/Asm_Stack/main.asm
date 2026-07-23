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
            mov.w     #0AAAAh, R4                        ; initialize data in register R4
            mov.w     #0BBBBh, R5                        ; initialize data in register R5

            push.w    R4                                 ; push 16 bit word onto stack
            push.w    R5                                 ; push 16 bit word onto next stack address, push will increment SP 

            pop.w     R6                                 ; REMOVE DATA AND POP INTO REGISTER R6
            pop.w     R7                                 ; REMOVE DATA AND POP INTO REGISTER R7

            jmp       main
            
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
