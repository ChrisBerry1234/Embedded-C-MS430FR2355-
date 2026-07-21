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
           mov.w     #0, R4
           jmp       do_this_1st                         ; calculates the offset of where the label is and apply it to the PC

do_this_2nd: 
           mov.w     #2, R4
           jmp       done                                 ; calculates the offset of where the label is and apply it to the PC

do_this_1st:
           mov.w    #1, R4
           jmp      do_this_2nd                            ; calculates the offset of where the label is and apply it to the PC

done:
           jmp      #main                                   ; uses immediate addressing, if we just do main, it will go to the a

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
