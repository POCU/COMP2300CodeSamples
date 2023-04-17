    .PROCESSOR 6502
    .ORG $8000

VAL=%01011000
r=$80
    ldx #$FF
    txs

    lda #VAL
    rol
    ror r
    rol
    ror r
    rol
    ror r
    rol
    ror r

    rol
    ror r
    rol
    ror r
    rol
    ror r
    rol
    ror r

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000
