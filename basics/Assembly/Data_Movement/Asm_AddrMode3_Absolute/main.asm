;-----------------------------------------
;Main Loop Here
;-----------------------------------------

main:
        mov.w &2000h, R4  ; move data stored in data memory address 2000h to Register 4
        mov.w R4, &2004h  ; move data stored in register 4 to data memory address 2004h

        mov.w &2002h, R5  ; move data stored in data memory 2002h to register 5
        mov.w R5, &2006h  ; move data stored in register 5 to data memory 2006h
        
        jmp   main


;---------------------------------------
;Memory Allocation
;----------------------------------------
        .data               ; go data memory 2000h
        .retain             ; DO NOT OPTIMIZE

Const1: .short    1234h     ; 1234h @2000h
Const2: .short    0CAFEh    ; 0CAFEh @2002h

Var1:   .space     2        ; reserve 2 bytes @ 2004h 
Var1:   .space     2        ; reserve 2 bytes @ 2006h
