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
            bis.b    #BIT0, &P1DIR                       ; set p1.0 as a output
            bic.b    #BIT0, &P1OUT                       ; clear p1OUT.0 and set LED off
            bic.b    #LOCKLPM5, &PM5CTL0                 ; enabled digit I/O
            
;----timer setup B0
            bis.w    #TBCLR, &TB0CTL                     ; clear TB0
            bis.w    #TBSSEL__ACLK, &TB0CTL              ; choose ACLK
            bis.w    #MC__UP, &TB0CTL                    ; put into "up" mode

;-----setup compares
            mov.w    #32767, &TB0CCR0                    ; put calculated values into Compare Register 0          
            mov.w    #1638,  &TB0CCR1                    ; put calculated values into Compare Register 1
            
;-----timer overflow IRQ setup
            bis.w    #CCIE, &TB0CCTL0                     ; enable interrupt for capture
            bis.w    #CCIE, &TB0CCTL1                     ; enable interrupt for capture 
            
            bis.w    #GIE, SR                             ; enable global interrupt for all maskables
            
            bis.w    #CCIFG, &TB0CCTL0                    ; clear interrupt flag for IRQ assertion
            bis.w    #CCIFG, &TB0CCTL1                    ; clear interrupt flag for IRQ assertion
main:         
            jmp      mai;
            
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Interrupt Service Routines
;---------------------------------------------------------
ISR_TB0_CCR1:
            bic.b      #BIT0, &P1OUT                      ; turn LED off
            bic.w      #CCIFG, &TB0CCTL1                   ; clear Interrupt Flag
            reti
            
ISR_TB0_CCR0:
            bis.b       #BIT0, &P1OUT                      ; turn LED1 On
            bic.w       #CCIFG, &TB0CCTL0                   ; clear Timer Compare IFG otherwise interrupt will continue to run
            reti
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 

            .sect     ".int42"                              ; init vector table for CCR0
            .short    ISR_TB0_CCR0

            .sect     ".int43"                              ; init vector table for Compare Register 1
            .short    ISR_TB0_CCR1
