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
           mov.w     #Const1, R4                        ; load initialize starting address into R4
           mov.b     @R4, R5                            ; put the lower 8 bits into R5 
           inc       R4                                 ; inc to next memory address (odd since .b not .w) and put replace the previous address in R5
           mov.b     @R4, R6                            ; put the high 8 bits into R6

           inc       R4                                 ; increment to memory address 2002h 

           mov.w     @R4, R7                            ; put the whole 16 bit word into the 16 bit register 

           incd      R4                                 ; double increment and go to increment memory address 2004h
           mov.w     @R4, R8                            ; put the 16-bit value into the 16 bit value

           jmp       main
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
            .data                                        ; go to data memory @ 2000h
            .retain                                      ; DO NOT OPTIMIZE 

Const1:     .short   1234h                                ; allocate consecutive blocks of Data Memory
            .short   5678h
            .short   9ABCh


;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
