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
            mov.b    #00000001b, R4                      ; insert 10101010b into R4
            clrc                                         ; clear carry flag for rotate into carry
            rlc.b    R6
            rlc.b    R6
            rlc.b    R6
            rlc.b    R6
            rlc.b    R6
            rlc.b    R6
            rlc.b    R6
            rlc.b    R6
            rlc.b    R6
            rlc.b    R6                                    ; C=1
            rlc.b    R6                                    ; Carry bit rolls over into LSB

            mov.b    #10000000b, R5                        ; insert 10000000b into R5
            clrc    
            rrc.b    R5
            rrc.b    R5
            rrc.b    R5
            rrc.b    R5
            rrc.b    R5
            rrc.b    R5
            rrc.b    R5
            rrc.b    R5
            rrc.b    R5
            rrc.b    R5                                      ; C = 1
            rrc.b    R5                                      ; Carry bit rolls over into MSB
     
            
            jmp      main   

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
