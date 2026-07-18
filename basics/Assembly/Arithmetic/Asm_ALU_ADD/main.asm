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

            mov.w    #290, R4                            ; put 290 into R4
            mov.w    #300, R5                            ; put 300 into R5
            add.w    R4, R5                              ; R5 = R5 + R4 (SR = 0000)

            mov.w    #0FFFEh, R6                         ; put FFFEH into R6
            add.w    #0001h, R6                          ; R6 = 1 + R6 (SR = 0100, Negative Flag is set)

            mov.w    #0FFFFh, R7                         ; put FFFFh into R7
            add.w    #1h, R7                             ; R7 = #1h + R7 (SR = 0011, Carry Flag and Overflow Flag are set)

            mov.b    #255, R8                            ; put 255 into R8
            mov.b    #1, R9                              ; put 1 into R9
            add.b    R8, R9                              ; R9 = R8 + R9 (SR =  0011, Carry Flag and Zero Flag are set)

            mov.b    #-1, R10                            ; put -1 into R10 (Signed Int)
            add.b    #1, R10                             ; R10 = R10 + 1 (SR = 0011, Carry Flag and Zero Flag are set)

            mov.b    #127, R11                           ; put 127 into R11
            add.b    #127, R11                           ; R11 = 127 + R11 (V Flag set because result does not fit within range of an 8-bit signed #)
            
            jmp      main
            
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------

;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
