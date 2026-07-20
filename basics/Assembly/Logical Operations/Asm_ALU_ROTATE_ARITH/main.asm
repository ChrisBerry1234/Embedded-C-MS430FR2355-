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
            rla.b    R4 
            rla.b    R4
            rla.b    R4
            rla.b    R4
            rla.b    R4
            rla.b    R4
            rla.b    R4
            rla.b    R4                                   ; 8th Rotate produces a carry so C=1
            rla.b    R4                          

            mov.b    #10000000b, R5                       ; insert 10000000b into R5
            clrc
            rra.b    R5
            rra.b    R5
            rra.b    R5
            rra.b    R5
            rra.b    R5
            rra.b    R5
            rra.b    R5
            rra.b    R5                                     ; 8th rotate produces a carry flag
            
            jmp      main   

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
