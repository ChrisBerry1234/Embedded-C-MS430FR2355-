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

            mov.w      #0, Var2
while:      

if:        
            cmp.w      #10, Var2
            jnz        else 

            mov.w      #0, Var2 
            jmp        end_if
else:
            inc         Var2
end_if:

end_while:
            jmp         while

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
            .data
            .retain

Var1        .space      2
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
