TITLE Sum From 1 to N

.DOSSEG
.8086
.NO87
.MODEL TINY

.DATA
num DW 20
res DW ?

.CODE
.STARTUP
    push num
    call sum
    add sp, 2 ; stack cleanup

    mov res, ax

    mov ah, 4Ch
    xor al, al
    int 21h

sum PROC ; (s[0]) -> ax | <cx,flags>
;==========================================
; summary:   Calculates the sum from 1 to n
;
; arguments: s[0]   n
;
; returns:   ax     The sum from 1 to n
;
; modifies:  cx
;            flags
;==========================================
    push bp
    mov bp, sp

    mov cx, [bp+4]
    xor ax, ax

loop_sum:
    add ax, cx
    loop loop_sum

    pop bp
    ret
sum ENDP
END