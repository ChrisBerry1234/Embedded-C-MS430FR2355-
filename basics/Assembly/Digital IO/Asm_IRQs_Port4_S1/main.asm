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
            bis.b    #BIT0, &P1DIR                       ; sets P1.0
            bic.b    #BIT0, &P1OUT                       ; set LED1 Off

            bic.b    #BIT1, &P4DIR                       ; set P4.1 to input (S1)
            bis.b    #BIT1, &P4REN                       ; enabled pull up/down resistor
            bis.b    #BIT1, &P4OUT                       ; make the resistor a pull up
            bis.b    #BIT1, &P4IES                       ; sensitivity is HIGH-to-LOW

            bic.b    #LOCKLPM5, &PM5CTL0                 ; enable Digital I/O

            bic.b    #BIT1, &P4IFG                       ; clear P4IFG
            bis.b    #BIT1, &P4IE                        ; set local enable for P4.1
            eint                                         ; enable global maskables
            
main: 
            jmp       main
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Interrupt Service Routines
;---------------------------------------------------------
ISR_S1:
            xor.b       #BIT0, &P1OUT                         ; toggle LED1
            bic.b       #BIT1, &P4IFG                        ; clear P4IFG otherwise interrupt will continue to run
            reti
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
;--------------------------------------------------------
; Interrupt Vectors
;---------------------------------------------------------
            .sect      ".reset"                                ; MSP430 RESET Vector Highest Priority Vector
            .short     RESET                                 ; ISR ADDRESS

            .sect      ".int22"                                ; port 4 vector table
            .short     ISR_S1                                  ; ISR ADDRESS
