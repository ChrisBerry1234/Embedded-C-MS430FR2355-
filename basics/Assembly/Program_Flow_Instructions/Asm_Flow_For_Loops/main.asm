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
            mov.w    #0, R4                              ; initialize i = 0 

forloop1:   
            mov.w    R4, Var1                            ; inner loop variable to track i
            
            inc      R4 
            cmp.w    Var, R4                             ; as we increment, compare and subtract values
            jnz      forloop1                            ; if values are equal, check status flags, if Z, then move onto next loop

forloop2:   
            mov.w    #10, R5                             ; initialize next R5 for next loop

            mov.w    R5, Var2                            ; inner loop variable to track i
            decd     R5 
            tst      R5                                  ; as we decrement loop, tst to see if value is zero or negative
            jge      forloop2                            ; if N == V, branch and continue loop
            
endloops:    jmp      main
                      
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
            .data
            .retain

Var:        .short      4
Var1:       .space      2
Var2:       .space      2

;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
