TITLE uitoa

.DOSSEG
.8086
.NO87
.MODEL TINY

.CODE
.STARTUP
    mov ax, 2697
    push ax
    call uitoa
    add sp, 2

    mov ah, 4Ch
    xor al, al
    int 21h

uitoa PROC ;(s[0]) <ax,bx,dx,flags>
;==============================================
; summary:   Converts a 16-bit unsigned integer
;            to string and prints it to the
;            console
;
; arguments: s[0]   A 16-bit unsigned integer
;
; modifies:  ax
;            bx
;            dx
;            flags
;==============================================
    MAX_DIGITS EQU 5

    push bp
    push si
    push di
    mov bp, sp
    sub sp, MAX_DIGITS+1

    mov ax, [bp+8]
    lea di, [bp-1]
    mov BYTE PTR [di], '$'
    mov bx, 10

next_digit:
    xor dx, dx
    div bx
    or dl, '0'
    dec di
    mov [di], dl
    test ax, ax
    jnz next_digit

print:
    lea dx, [di]
    mov ah, 9h
    int 21h

    mov sp, bp
    pop di
    pop si
    pop bp
    ret
uitoa ENDP
END