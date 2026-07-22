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
          mov.w       #0,  VarIn
          mov.w       #0,  VarOut
          
while:

switch:
          cmp.w         #0, VarIn
          jz            case0
          cmp.w         #1, VarIn
          jz            case1
          cmp.w         #2, VarIn
          jz            case2
          cmp.w         #3, VarIn
          jz            case3
          jmp           default
          
case0:  
          mov.w         #1, VarOut
          jmp           end_switch 
          
case1:    
          mov.w          #2, VarOut
          jmp            end_switch

case2:
          mov.w           #3, VarOut
          jmp             end_switch
          
case3:
          mov.w           #4, VarOut
          jmp             end_switch
          
default:
           mov.w          #0, VarOut 

end_switch:
end_while:
            jmp      while 
                      
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
            .data
            .retain

VarIn       .space     2
VarOut      .space     2
;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
