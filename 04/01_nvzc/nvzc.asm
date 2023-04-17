    .PROCESSOR 6502
    .ORG $8000

out=$4000
    ldx #$FF
    txs

    clc

    ; 1. pos + neg = pos
    lda #%00101101  ; 45
    adc #%11011111  ; -33

    sta out

    clc

    ; 2. pos + neg = neg
    lda #%00101101  ; 45
    adc #%11001110  ; -50
    sta out

    clc

    ; 3. pos + pos (no overflow)
    lda #%00101101  ; 45
    adc #%01010000  ; 80
    sta out

    clc

    ; 4. pos + pos (overflow)
    lda #%00101101  ; 45
    adc #%01010011  ; 83
    sta out

    clc

    ; 5. neg + neg (no overflow)
    lda #%10011100  ; -100
    adc #%11101100  ; -20
    sta out

    clc

    ; 6. neg + neg (overflow)
    lda #%10011100  ; -100
    adc #%11100011  ; -28
    sta out

    clc

    ; 7. result is zero
    lda #%10011100  ; -100
    adc #%01100100  ; 100
    sta out
    
    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000
