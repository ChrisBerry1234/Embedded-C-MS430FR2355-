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
;----setup LED initially
            bis.b    #BIT0, &P1DIR
            bic.b    #BIT0, &P1OUT
            bic.b    #LOCKLPM5, &PM5CTL0                 ; enabled digit I/O

;----timer setup B0
            bis.w    #TBCLR, &TB0CTL                     ; clear TB0
            bis.w    #TBSSEL__ACLK, &TB0CTL              ; choose ACLK
            bis.w    #MC__CONTINUOUS, &TB0CTL            ; put into continuous mode
            bis.w    #CNTL_1, &TB0CTL                    ; puts timer into 12-bit mode

;-----timer overflow IRQ setup
            bis.w    #TBIE,  &TB0CTL                     ; local enable for TB0 overflow
            bis.w    #GIE, SR                            ; enable global interrupt for all maskables
            bic.w    #TBIFG, &TB0CTL                     ; clear Interrupt flag for IRQ assertion
main:        
            jmp      main
            
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Interrupt Service Routines
;---------------------------------------------------------
ISR_TB0_Overflow:
            xor.b       #BIT0, &P1OUT                         ; toggle LED1
            bic.b       #TBIFG, &TB0CTL                       ; clear P4IFG otherwise interrupt will continue to run
            reti
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 

            .sect     ".int42"                                 ; init vector table for TB0 overflow
            .short    ISR_TB0_Overflow 
