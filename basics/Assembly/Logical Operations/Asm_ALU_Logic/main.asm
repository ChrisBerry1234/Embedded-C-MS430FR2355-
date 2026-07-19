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
            mov.b    #10101010b, R4                      ; insert 10101010b into R4
            inv.b    R4                                  ; inversion gives us 01010101b

            mov.b    #11110000b, R5                      ; insert 11110000b into R5
            and.b    #00111111b, R5                      ; preserve bits 6 & 7

            mov.b    #00010000b, R6                      ; is bit 7 a 1 or 0?
            and.b    #10000000b, R6

            mov.b    #00010000b, R7                      ; is bit 4 a 1 or 0? 
            and.b    #00010000b, R7

            mov.b    #11000001b, R8                      ; set lower 5 bits, preserve upper 3
            or.b     #00011111b, R8

            mov.b    #01010101b, R9
            xor.b    #11110000b, R9                      ; toggle the upper 4 bits 
            xor.b    #00001111b, R9                      ; toggle the lower 4 bits

            jmp      main   

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
