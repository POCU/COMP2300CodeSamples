TITLE Is Prime Number

.DOSSEG
.8086
.NO87
.MODEL TINY

.DATA
num           DW 13
msg_prime     DB "Number is prime$"
msg_not_prime DB "Number is not prime$"

.CODE
.STARTUP
    push num
    call isprime
    add sp, 2 ; stack cleanup

    mov ah, 4Ch
    xor al, al
    int 21h

isprime PROC ; (s[0]) <ax,bx,cx,dx,flags>
;========================================
; summary:   Prints "Number is prime"
;            if n is a prime number.
;            Prints "Number is not prime"
;            if n is not a prime number
;
; arguments: s[0]
;
; modifies:  ax
;            bx
;            cx
;            dx
;            flags
;========================================
    push bp
    mov bp, sp

    mov bx, [bp+4]

    mov cx, bx
    dec cx
    jbe not_prime

loop_prime:
    mov ax, bx
    xor dx, dx
    idiv cx
    cmp dx, 0
    loopne loop_prime

    cmp cx, 0
    je prime

not_prime:
    lea dx, msg_not_prime
    jmp print

prime:
    lea dx, msg_prime

print:
    mov ah, 09h
    int 21h

    pop bp
    ret
isprime ENDP

END