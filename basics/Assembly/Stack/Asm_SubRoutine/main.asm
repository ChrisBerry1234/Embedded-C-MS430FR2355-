;---------------------------------------------------
; MSP430 Assembly - Subroutines Example
;---------------------------------------------------

            .cdecls C, LIST, "msp430.h"

            .def    RESET

            .text
            .retain
            .retainrefs


RESET:
            mov.w    #__STACK_END, SP        ; Initialize stack pointer
            mov.w    #WDTPW|WDTHOLD, &WDTCTL ; Stop watchdog


;---------------------------------------------------
; Main Program
;---------------------------------------------------

main:

            mov.w     #75, R4               ; Immediate Addressing: Load 75 into R4

            tst.w     R4                    ; Test R4 against zero
                                            ; Performs R4 - 0
                                            ; Updates flags only

            jz        end_program           ; Jump if Z=1 (R4 == 0)

            call      #dbdecrement_it       ; Call subroutine


end_program:

            call      #complement_it        ; Call complement subroutine

            jmp       main                  ; Repeat forever


;---------------------------------------------------
; Subroutines
;---------------------------------------------------

dbdecrement_it:

            decd.w    R4                    ; Decrement R4 by 2
            ret                             ; Return to caller


complement_it:

            inv.w     R4                    ; Invert all bits in R4
            ret                             ; Return to caller


;---------------------------------------------------
; Stack
;---------------------------------------------------

            .global    ___STACK_END
            .sect      .stack
