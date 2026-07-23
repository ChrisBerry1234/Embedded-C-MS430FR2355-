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
            bis.b    #BIT0, &P1DIR                       ; set P1 to be out as output by toggling BIT0 
            bic.b    #BIT0, &P1OUT                       ; turn led1 off

            bic.b    #BIT1, &P4DIR                       ; set P4.1 as input. P4.1 = S1
            bis.b    #BIT1, &P4REN                       ; enable resistor to be pullup/pulldown
            bis.b    #BIT1, &P4OUT                       ; configure register as as a pull up

            bic.b    #LOCKLPM5, &PM5CTL0                 ; enabled digit I/O

main:      

poll:       
            bit.b    #BIT1, &P4IN                         ; now that we have configured everything, we want to check if the switch has been pressed. 
            jnz      poll                                 ; continue polling until condition is no longer satisfied

toggle_LED:
            xor.b    #BIT0, &P1OUT                        ; if not zero, toggle LED1
                                          
delay:     
            mov.w    #0FFFFh, R6                          ; initialize for loop variable

loop:       
            dec.w    R6                                   ; decrement counter 
            tst.w    R6                                   ; tst R6 against 0 by subtracting against zero 
            jnz      loop                                 ; continue to dec, if not zero then continue loop 
            
            jump     main                                 ; once done, jump to main and repeat
            
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
