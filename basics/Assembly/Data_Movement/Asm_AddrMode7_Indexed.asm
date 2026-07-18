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
            mov.w    #Block1,  R4                      ; initialize starting address to 2000h
            mov.w    0(R4),  8(R4)                     ; go to index 0(2000h) and OFFSET to position 8 (2008h)
            mov.w    2(R4), 10(R4)                     ; go to index 2(2002h) and OFFSET to position 10 (200Ah)
            mov.w    4(R4), 12(R4)                     ; go to index 4(2004h) and OFFSET to position 12 (200Ch)
            mov.w    6(R4), 14(R4)                     ; go to index 6(2006h) and OFFSET to position 14 (200Eh)

            jmp      main

;--------------------------------------------------------
; Data Allocation
;---------------------------------------------------------

            .data                                     ; go to data memory @2000h
            .retain                                   ; Do not optomize 

Block1:     .short    0AAAAh, 0BBBBh, 0CCCCh, 0DDDDh  ; Sarting from 0x2000 in memory, place these blocks of data continously 
Block2:      space    2                               ; Allocate 2 blocks of memory, this will be where insert 


;--------------------------------------------------------
; Stack Pointer Definition
;--------------------------------------------------------
            .global    ___STACK_END
            .sect      .stack 
