    .PROCESSOR 6502
    .ORG $8000

str=$1000
copy=$1010
    ; push addr to the stack
    .MACRO phaddr ;(addr) <A,S,P>
        lda #<{1}
        pha
        lda #>{1}
        pha
    .ENDM

    ; pop arguments from the stack
    .MACRO popargs ;(startaddr,count) <A,S,P>
X .SET {2}-1
        .REPEAT {2}
            pla
            sta {1}+X
X .SET X-1
        .REPEND
    .ENDM

    ldx #$FF
    txs

    ;== DEFINE THE INPUT STRING HERE ==
    lda #'C
    sta str
    lda #'O
    sta str+1
    lda #'M
    sta str+2
    lda #'P
    sta str+3
    lda #'2
    sta str+4
    lda #'3
    sta str+5
    lda #'0
    sta str+6
    lda #'0
    sta str+7
    ;==================================

    phaddr str
    phaddr copy
    jsr strcpy

end:
    jmp end

strcpy: ;(s[0],s[2]) <A,X,Y,P,0x00~0x05,(s[0])>
;===============================================
; summary:   copy str from (s[2]) to (s[0])
;            
; arguments: s[0]   the address of the copy
;            s[2]   the address of the original
;
; modifies:  (s[0])
;            A
;            X
;            Y
;            P
;            0x00~0x05
;===============================================
    .SUBROUTINE
vsrc=$00
vdst=vsrc+2
vretaddr=vdst+2
POPCNT=vretaddr+2-vsrc
    
    popargs vsrc, POPCNT

    ldy #$FF
.loop:
    iny
    lda (vsrc),y
    sta (vdst),y
    bne .loop

    ; restore the stack
    lda vretaddr
    pha
    lda vretaddr+1
    pha
    
    rts
;================================================

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000