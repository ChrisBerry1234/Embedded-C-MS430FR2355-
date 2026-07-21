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
while1:    
            cmp.w   #3, Var1                             ; compare 3 to variable stored, if equal, Z = 0
            jnz     end_while1                           ; if not equal to zero and values do not match

            mov.w   #1, Var2                             ; while condition is satisfied, move 1 to Var 2
            jmp     while1                               ; repeat loop
end_while1:

while2: 
             mov.w   #2, Var2                             ; while loop that executes forever
             jmp     while2                               ; repeat loop
end_while2:

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
            .data
            .retain

Var1        .short   3
Var2        .short   2
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
