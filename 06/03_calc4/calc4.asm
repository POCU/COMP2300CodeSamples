    .PROCESSOR 6502
    .ORG $8000

PG1=$0100
FNADD=0
FNSUB=1
FNLSHIFT=2
FNRSHIFT=3
num0=$4000
num1=$4001
op=$4002    ; 0 = +, 1 = -, 2 = <, 3 = >
opaddr=$10;
out=$12
    ldx #$FF
    txs

    ; == DEFINE INPUTS HERE ===
    lda #12
    sta num0

    lda #16
    sta num1

    lda #FNSUB
    sta op
    ; =========================
    ldx op

    lda tablelo,x
    sta opaddr
    lda tablehi,x
    sta opaddr+1

    pha ; return value placeholder
    lda num1
    pha
    lda num0
    pha

    lda #>ret-1 ; return address
    pha
    lda #<ret-1
    pha

    jmp (opaddr)
ret:
    pla
    pla

    pla ; return value

    sta out

end:
    jmp end

add: ;(s[0],s[1]) -> s[2] | <A,X,P>
;====================================
; summary:   Calculates s[0] + s[1]
;            
; arguments: s[0]   The 1st number
;            s[1]   The 2nd number
;
; returns:   s[2]   s[0] + s[1]
;
; modifies:  A
;            X
;            P
;====================================
    tsx

    clc
    lda PG1+3,x
    adc PG1+4,x
    sta PG1+5,x

    rts
;====================================

sub: ;(s[0],s[1]) -> s[2] | <A,X,P>
;====================================
; summary:   Calculates s[0] - s[1]
;            
; arguments: s[0]   The 1st number
;            s[1]   The 2nd number
;
; returns:   s[2]   s[0] - s[1]
;
; modifies:  A
;            X
;            P
;====================================
    tsx

    sec
    lda PG1+3,x
    sbc PG1+4,x
    sta PG1+5,x

    rts
;====================================

lshift: ;(s[0],s[1]) -> s[2] | <A,X,Y,P>
;==============================================
; summary:   Left shift s[0] by s[1]
;            
; arguments: s[0]   The number to left shift
;            s[1]   The number of bits to shift
;
; returns:   s[2]   s[0] << s[1]
;
; modifies:  A
;            X
;            Y
;            P
;==============================================
    .SUBROUTINE
    tsx

    lda PG1+3,x
    ldy PG1+4,x
    
.loop:
    beq .ret
    asl
    dey
    jmp .loop

.ret:
    sta PG1+5,x

    rts
;==============================================

rshift: ;(s[0],s[1]) -> s[2] | <A,X,Y,P>
;==============================================
; summary:   Right shift s[0] by s[1]
;            
; arguments: s[0]   The number to right shift
;            s[1]   The number of bits to shift
;
; returns:   s[2]   s[0] >> s[1]
;
; modifies:  A
;            X
;            Y
;            P
;==============================================
    .SUBROUTINE
    tsx

    lda PG1+3,x
    ldy PG1+4,x

.loop:
    beq .ret
    lsr
    dey
    jmp .loop

.ret:
    sta PG1+5,x

    rts
;==============================================

    .ORG $C000,0
tablelo:
    .BYTE <add      ; index = 0
    .BYTE <sub      ; index = 1
    .BYTE <lshift   ; index = 2
    .BYTE <rshift   ; index = 3

tablehi:
    .BYTE >add      ; index = 0
    .BYTE >sub      ; index = 1
    .BYTE >lshift   ; index = 2
    .BYTE >rshift   ; index = 3

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000