    .PROCESSOR 6502
    .ORG $8000

LEN=enums0-nums0
; arrsum() args
pnums0=$00
pnums1=$02
pres=$04    ; out
plen=$06
res=$1000
    ldx #$FF
    txs

    lda #<nums0
    sta pnums0
    lda #>nums0
    sta pnums0+1

    lda #<nums1
    sta pnums1
    lda #>nums1
    sta pnums1+1

    lda #<res
    sta pres
    lda #>res
    sta pres+1

    lda #LEN
    sta plen

    jsr arrsum

end:
    jmp end

arrsum: ;(pnums0,pnums1,pres,plen) <A,X,Y,P,(pres)>
;==================================================
; summary:   Calculates the element-wise
;            sum of two arrays
;            
; arguments: pnums0   The 1st array's address
;            pnums1   The 2nd array's address
;            pres     The result array's address
;            plen     The length of the arrays
;
; modifies:  A
;            X
;            Y
;            P
;            (pres)
;==================================================
    .SUBROUTINE
    ldy plen
    dey

.loop:
    lda (pnums0),y
    adc (pnums1),y
    sta (pres),y
    dey
    bpl .loop

    rts
;==================================================

    .ORG $C000,0
nums0:
    .BYTE $01, $02, $03, $04, $05, $06
enums0:
nums1:
    .BYTE $11, $12, $13, $14, $15, $16
enums1:

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000