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
            mov.b     #0FFh, R4          ; Immediate Addressing: Load the value of 0FFh into R4
            mov.b     #01h, R5           ; Immediate Addressing: Load the value of 01h into R5
            sub.b     R5, R4             ; No borrow required so C=1 and N=1 because MSB = 1, Difference = FEh

            mov.b     #01h, R6           ; Immediate Addressing: Load the value 01h into R7
            mov.b     #0FFh, R7          ; Immediate Addressing: Load the value 0FFh into R8
            sub.b     R7, R6             ; Borrow required so C=0 and N = 0 because MSB = 0, Difference = 02h

            jmp       main               ; Jump Instruction: Repeat program execution
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
