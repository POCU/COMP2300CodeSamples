TITLE Sum from 1 to N Without loop

.DOSSEG
.8086
.NO87
.MODEL TINY

.DATA
num DW 20
res DW ?

.CODE
.STARTUP
; Calculates the sum from 1 to n
sum MACRO n ; (n) -> ax | <flags>
    mov ax, n
    inc ax
    imul n
    sar ax, 1
ENDM
    
    sum num

    mov res, ax

    mov ah, 4Ch
    xor al, al
    int 21h

END
