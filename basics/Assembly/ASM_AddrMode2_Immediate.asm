;========================================
; Immediate Addressing Examples (MSP430)
;========================================

; Load decimal constant
mov.w   #100, R4          ; R4 = 100

; Load hexadecimal constant
mov.w   #0x1234, R5       ; R5 = 0x1234

; Load maximum unsigned byte
mov.b   #0xFF, R6         ; Lower byte of R6 = 0xFF

; Load binary value
mov.b   #0b10101010, R7   ; R7 = 0xAA

; Load zero
mov.w   #0, R8            ; Clear R8 using immediate value

; Load negative number
mov.w   #-25, R9          ; Two's complement representation
