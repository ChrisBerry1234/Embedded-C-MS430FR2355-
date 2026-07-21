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
            mov.b    #25, R6                              ; insert 10101010b into R4
            clrc                                          ; clear carry flag for rotate into carry
            rla.b    R4                                   ; dec = 50
            rla.b    R6                                   ; dec = 100
            rla.b    R6                                   ; dec = 200
            rla.b    R6                                   ; dec = 144, falls apart due to carry at MSB 
 
            mov.b    #10000000b, R7                       ; insert 10000000b into R5
            clrc                                          ; clear before initial rotate 
            rrc.b    R7                                   ; dec = 112
            clrc                                          ; clear carry after every rotate to prevent MSB = 1
            rrc.b    R7                                   ; dec = 56
            clrc 
            rrc.b    R7                                   ; dec = 28
            clrc 
            rrc.b    R7                                   ; dec = 14
            clrc    
            rrc.b    R7                                   ; dec = 7
            clrc 
            rrc.b    R7                                   ; dec = 3, starts losing accuracy as bits rotate into carry and get cleared
            clrc 
            rrc.b    R7
            clrc 
            rrc.b    R7                                   ; dec = 0
            
     
            
            jmp      main   

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
