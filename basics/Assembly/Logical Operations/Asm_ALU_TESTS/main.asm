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
           mov.b    #00010000b, R4                       ; intialize R4 with binary value 00010000
           bit.b    #10000000b, R4                       ; if bit 7 was a 1, it would remain the same, instead remains 0. Z flag = 1
           bit.b    #00010000b, R4                       ; testing if bit 4 is equal to 1, masking with a 1 leads to dst value remaining the same, Z flag = 0 so no.

           mov.b    #99, R5                              ; initialize R5 to 99
           cmp.b    #99, R5                              ; cmp subtracts(99-99) so Z flag = 1
           cmp.b    #77, R5                              ; cmp subtracts(99-77) so Z flag = 0

           mov.b   #-99, R6                              ; is R6 zero?
           tst.b   R6                                    ; N =1, Z=0, C=1

           jmp      main   

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
