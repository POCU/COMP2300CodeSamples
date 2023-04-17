    .PROCESSOR 6502
    .ORG $8000

PG1=$0100
perimres=$10
sareares=$11
ind=$20
    ; push val to the stack
    .MACRO phval ;(val) <A,S,P>
        lda #{1}
        pha
    .ENDM

    ; Calculates the product of num0 and num1
    .MACRO mul ;(num0,num1) -> A | <X,Y,P,ind,ind+1>
        ldx {1}
        ldy rowlo,x
        sty ind
        ldy rowhi,x
        sty ind+1

        ldy {2}
        lda (ind),y
    .ENDM

    ; cleans the stack after a function call
    .MACRO clnstack ;(count) <X,S,P>
        tsx
        .REPEAT {1}
            inx
        .REPEND
        txs
    .ENDM

    ; clnstack and set A = return value
    .MACRO getret ;(count) <A,X,S,P>
        clnstack {1}
        pla
    .ENDM

    ldx #$FF
    txs

    pha ; return value place holder
    phval 2
    phval 5
    jsr perim

    clnstack 2
    pla
    sta perimres

    pha ; return value place holder
    phval 3
    phval 4
    phval 2
    jsr surfarea

    clnstack 3
    pla
    sta sareares

    pha ; return value place holder
    phval 6
    phval 3
    phval 3
    jsr surfarea

    getret 3
    sta sareares

end:
    jmp end

perim: ;(s[0],s[1]) -> s[2] | <A,X,P>
;=================================================
; summary:   Calculates the perimeter of a
;            rectangle
;            
; arguments: s[0]   Width
;            s[1]   Height
;
; returns:   s[2]   The perimeter of the rectangle
;
; modifies:  A
;            X
;            P
;=================================================
    tsx

    clc
    lda PG1+3,x
    adc PG1+4,x
    asl
    sta PG1+5,x

    rts
;=================================================

surfarea: ;(s[0],s[1],s[2])->s[3]|<A,X,P,0x00~05>
;==================================================
; summary:   Calculates the surface area of a
;            cuboid
;            
; arguments: s[0]   Width
;            s[1]   Length
;            s[2]   Height
;
; returns:   s[3]   The surface area of the cuboid
;
; modifies:  A
;            X
;            P
;            0x00~05
;==================================================
vwidth=$00
vlength=$01
vheight=$02
vtb=$03
vfb=$04
    tsx

    lda PG1+3,x
    sta vwidth
    lda PG1+4,x
    sta vlength
    lda PG1+5,x
    sta vheight

    ; top and bottom
    mul vwidth, vlength
    asl
    sta vtb

    ; front and back
    mul vwidth, vheight
    asl
    sta vfb

    ; left and right
    mul vlength, vheight
    asl

    clc
    adc vtb
    adc vfb

    tsx
    sta PG1+6,x

    rts
;==================================================

    .ORG $C000,0
multbl:
Y .SET 0
    .REPEAT 16
X .SET 0
        .REPEAT 16
            .byte Y*X
X .SET X+1
        .REPEND
Y .SET Y+1
    .REPEND

rowlo:
Y .SET 0
    .REPEAT 16
        .byte <(multbl+16*Y)
Y .SET Y+1
    .REPEND

rowhi:
Y .SET 0
    .REPEAT 16
        .byte >(multbl+16*Y)
Y .SET Y+1
    .REPEND

    .ORG $FFFC,0
    .WORD $8000
    .WORD $0000
