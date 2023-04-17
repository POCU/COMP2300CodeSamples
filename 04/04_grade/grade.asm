    .PROCESSOR 6502
    .ORG $8000

out=$4000
in=$4001

    ldx #$FF
    txs

    ; == DEFINE INPUT HERE ===
    lda #63
    sta in
    ; ========================

    lda in

    cmp #90
    bcc b
    lda #'A
    jmp print

b:
    cmp #80
    bcc c
    lda #'B
    jmp print

c:
    cmp #70
    bcc d
    lda #'C
    jmp print

d:
    cmp #60
    bcc f
    lda #'D
    jmp print

f:
    lda #'F

print:
    sta out

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000
