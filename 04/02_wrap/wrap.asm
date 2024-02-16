    .PROCESSOR 6502
    .ORG $8000

sum=$4000
base=$FE
    ldx #$FF
    txs

    lda #1
    sta $00

    lda #2
    sta $01

    lda #3
    sta $FE

    lda #4
    sta $FF

    clc

    lda base
    ldx #1
    adc base,X
    inx
    adc base,X
    inx
    adc base,X
    sta sum

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000