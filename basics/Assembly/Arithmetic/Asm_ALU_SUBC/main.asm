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
