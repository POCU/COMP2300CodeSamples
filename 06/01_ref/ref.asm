    .PROCESSOR 6502
    .ORG $8000

; mul() args
p00=$00
p01=$01
; mmm() related
p10=$02
p11=$03
v10=$04
pmin=$05 ; out
pmax=$07 ; out
min=$1000
max=$1001
    ldx #$FF
    txs

    lda #3
    sta p10

    lda #5
    sta p11

    lda #<min
    sta pmin
    lda #>min
    sta pmin+1

    lda #<max
    sta pmax
    lda #>max
    sta pmax+1

    jsr mmm

end:
    jmp end

mmm: ;(p10,p11,pmin,pmax)->A,(pmin),(pmax)|<X,Y,P>
;=================================================
; summary:   Calculates the product, the minimum
;            and the maximum of p10 and p11
;            
; arguments: p10      The 1st number
;            p11      The 2nd number
;            pmin     The address to store the
;                     minimum value
;            pmax     The address to store the
;                     maximum value
;
; returns:   A        p10 * p11
;            (pmin)   min(p10, p11)
;            (pmax)   max(p10, p11)
;
; modifies:  X
;            Y
;            P
;=================================================
    .SUBROUTINE
    ; mul
    lda p10
    sta p00
    lda p11
    sta p01
    jsr mul

    ; temp store
    sta v10

    ldy #0

    ; min/max
    lda p10
    cmp p11
    bcs .geq
    ; p10 < p11
    sta (pmin),y
    lda p11
    sta (pmax),y
    jmp .ret

.geq: ; p10 >= p11
    sta (pmax),y
    lda p11
    sta (pmin),y

.ret:
    lda v10
    rts
;=================================================

mul: ;(p10,p11) -> A | <X,SR> 
;=================================================
; summary:   Calculates the product of p10 and p11
;            
; arguments: p10  The 1st number
;            p11  The 2nd number
;
; returns:   A    p10 * p11
;
; modifies:  SR
;            X
;=================================================
    .SUBROUTINE
    lda #0
    ldx p01

    clc

.loop:
    beq .ret

    adc p00
    dex
    jmp .loop
.ret:
    rts
;=================================================

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000
