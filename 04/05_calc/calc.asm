    .PROCESSOR 6502
    .ORG $8000

num0=$1000
num1=$1001
op=$1002
out=$10
    ldx #$FF
    txs

    ; == DEFINE INPUTS HERE ===
    lda #12
    sta num0

    lda #16
    sta num1

    lda #'+
    sta op
    ; =========================

    lda num0 ; A = solution
    ldx op

    cpx #'+
    bne sub

    clc
    adc num1
    jmp end

sub:
    cpx #'-
    bne lshift

    sec
    sbc num1
    jmp end

lshift:
    cpx #'<
    bne rshift

    ldy num1

lloop:
    beq end
    asl
    dey
    jmp lloop

rshift:
    cpx #'>
    bne end

    ldy num1

rloop:
    beq end
    lsr
    dey
    jmp rloop

end:
    sta out

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000
