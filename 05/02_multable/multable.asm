    .PROCESSOR 6502
    .ORG $8000

num0=$10
num1=$11
DIM=9
res=$1000
    ldx #$FF
    txs

    ; == DEFINE OPERANDS HERE ===
    lda #3
    sta num0

    lda #5
    sta num1
    ; ===========================

    clc

    lda #0
    ldx num0

    ; find row
loop:
    dex
    beq findcol
    adc #DIM
    jmp loop

findcol:
    adc num1
    tax
    dex

    lda table,x
    sta res

    .ORG $C000,0
table:
    .BYTE 1,2,3,4,5,6,7,8,9
    .BYTE 2,4,6,8,10,12,14,16,18
    .BYTE 3,6,9,12,15,18,21,24,27
    .BYTE 4,8,12,16,20,24,28,32,36
    .BYTE 5,10,15,20,25,30,35,40,45
    .BYTE 6,12,18,24,30,36,42,28,54
    .BYTE 7,14,21,28,35,42,49,56,63
    .BYTE 8,16,24,32,40,48,56,64,72
    .BYTE 9,18,27,36,45,54,63,72,81

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000