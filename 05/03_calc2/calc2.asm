    .PROCESSOR 6502
    .ORG $8000

num0=$4000
num1=$4001
op=$4002    ; 0 = +, 1 = -, 2 = <, 3 = >
opaddr=$10
out=$12
    ldx #$FF
    txs

    ; == DEFINE INPUTS HERE ===
    lda #12
    sta num0

    lda #16
    sta num1

    lda #1
    sta op
    ; =========================

    clc

    lda op
    asl ; x 2
    tax

    lda table,x
    sta opaddr
    lda table+1,x
    sta opaddr+1

    lda num0 ; A = solution

    jmp (opaddr)

add:
    clc
    adc num1
    jmp end

sub:
    sec
    sbc num1
    jmp end

lshift:
    ldy num1

lloop:
    beq end
    asl
    dey
    jmp lloop

rshift:
    ldy num1

rloop:
    beq end
    lsr
    dey
    jmp rloop

end:
    sta out

    .ORG $C000,0
table:
    .WORD add       ; index = 0
    .WORD sub       ; index = 2
    .WORD lshift    ; index = 4
    .WORD rshift    ; index = 6

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000
