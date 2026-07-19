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
           mov.b    #00000000b, R4                        ;R4 = 00000000b 
           bis.b    #10000001b, R4                        
           bis.b    #01000010b, R4                        
           bis.b    #00100100b, R4                        
           bis.b    #00011000b, R4                        ;R4 = 11111111b

           bic.b    #00011000b, R4
           bic.b    #00100100b, R4
           bic.b    #01000010b, R4
           bic.b    #10000001b, R4                         ;R4 = 00000000b
           
           jmp      main   

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
