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
           mov.b     #0, R4                              ; initialize R4 with the value 0, if carry flag set, R4 =1, R4=2 if otherwise
main: 
           mov.b     #254, R5
           add.b     #1, R5                              ; C = 0
           jc        CarrySet
           jnc       CarryClear                          ; Need to list out both conditions

CarrySet:
           mov.b    #1, R4
           jmp      main                                 ; calculates the offset of where the label is and apply it to the PC

CarryClear:
           mov.b    #2. R4
           jmp      main                                ; uses immediate addressing, if we just do main, it will go to the a

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
