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
            mov.w     #Var1, R4          ; Immediate Addressing: Load the address of Var1 into R4
            mov.w     #Var2, R5          ; Immediate Addressing: Load the address of Var2 into R5
            mov.w     #Sum12, R6         ; Immediate Addressing: Load the address of Sum12 into R6

            ;-------------------------------------------------------
            ; Add lower 16-bit words
            ;-------------------------------------------------------

            mov.w     0(R4), R7          ; Indexed Addressing: Load the lower 16-bit word of Var1 into R7
            mov.w     0(R5), R8          ; Indexed Addressing: Load the lower 16-bit word of Var2 into R8
            add.w     R7, R8             ; Register Addressing: Add R7 to R8
            mov.w     R8, 0(R6)          ; Indexed Addressing: Store the lower 16-bit sum into Sum12

            ;-------------------------------------------------------
            ; Add upper 16-bit words (including carry)
            ;-------------------------------------------------------

            mov.w     2(R4), R7          ; Indexed Addressing: Load the upper 16-bit word of Var1 into R7
            mov.w     2(R5), R8          ; Indexed Addressing: Load the upper 16-bit word of Var2 into R8
            addc.w    R7, R8             ; Register Addressing: Add R7 and the Carry flag to R8
            mov.w     R8, 2(R6)          ; Indexed Addressing: Store the upper 16-bit sum into Sum12

            jmp       main               ; Jump Instruction: Repeat program execution
;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------
              .data
              .retain

  Var1:       .long      0E371FFFFh                        ; 32 bit value will be split amongst consecutive 16 bit memory addresses 2000h and 2002h
  Var2:       .long      11112222h                         ; 32 bit value will be split amongst consecutive 16 bit memory address 2004h and 2006h

  Sum12:      .space     4                                 ; allocate 4 bytes if memory so 32 bits (2 spots) in memory to hold the sum

;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
