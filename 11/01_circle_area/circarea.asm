TITLE Circle Area Calculator

.DOSSEG
.8086
.8087
.MODEL TINY

.DATA
result DW ?

.CODE
.STARTUP
    mov  ax, 3
    
    push ax
    call circle_area
    add  sp, 2
    
    mov  result, ax

    mov  ax, 43
    
    push ax
    call circle_area
    add  sp, 2

    mov  result, ax
    
    mov  ah, 4Ch
    xor  al, al
    int  21h

circle_area PROC NEAR ;(s[0]) -> ax | <flags>
;=============================================
; summary:   Calculates the area of a circle
;
; arguments: s[0]   Radius
;
; returns:   ax     The area, rounded to the
;                   nearest integer
;
; modifies:  flags
;==============================================
    push bp
    mov bp, sp

    finit

    fldpi
    fild    WORD PTR [bp+4]
    fmul    st, st
    fmul
    frndint
    fistp   WORD PTR [bp-2]

    fwait
    mov     ax, [bp-2]

    pop bp
    ret
circle_area ENDP
END
