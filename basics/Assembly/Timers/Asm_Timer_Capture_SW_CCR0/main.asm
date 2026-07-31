;---------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
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
;------setup port
;setup LED initially
            bis.b    #BIT0, &P1DIR                       ; set p1.0 as a output
            bic.b    #BIT0, &P1OUT                       ; clear p1OUT.0 and set LED off
            bic.b    #LOCKLPM5, &PM5CTL0                 ; enabled digit I/O

;setup Button Input
           bic.b    #BIT1, &P4DIR                       ; set P4.1 to input (S1)
           bis.b    #BIT1, &P4REN                       ; enabled pull up/down resistor
           bis.b    #BIT1, &P4OUT                       ; make the resistor a pull up
           bis.b    #BIT1, &P4IES                       ; sensitivity is HIGH-to-LOW
           
           bic.b    #LOCKLPM5, &PM5CTL0                 ; enable Digital I/O

;setup IRQ for SW1
            bic.b    #BIT1, &P4IFG                       ; clear P4IFG
            eint                                         ; enable global maskables
            bis.b    #BIT1, &P4IE                        ; set local enable for P4.1
           
;----timer setup B0
            bis.w    #TBCLR, &TB0CTL                     ; clear TB0
            bis.w    #TBSSEL__ACLK, &TB0CTL              ; choose ACLK
            bis.w    #ID__8, &TB0CTL                     ; div-by-4 in 1st stage 
            bis.w    #MC__CONTINUOUS, &TB0CTL            ; put into continous mode

;-----setup captures
            bis.w    #CAP, &TB0CCTL0                    ; put capture/compare registers into capture mode
            bis.w    #CM__BOTH, &TB0CCTL0                ; both edge sens
            bis.w    #CCIS_GND, &TB0CCTL0                ; input signal is gnd
            
;------init R4
            mov.w    #0, R4                              ; intializing variable to hold timer capture values
main:         
            jmp      main
            
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Interrupt Service Routines
;---------------------------------------------------------
ISR_S1:
           xor.b       #BIT0, P1OUT                       ; toggle LED
           xor.w       #CCIS0, &TB0CCTL0                  ; cause capture
           mov.w       &TB0CCR0, R4                       ; store off value
           bic.b       #BIT1, &P4IFG                      ; clear flag
           reti
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 

            .sect     ".int22"                              
            .short    ISR_
