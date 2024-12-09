TITLE 3D Transformation

.DOSSEG
.8086
.8087
.MODEL TINY

NUM_POINTS EQU 10

.DATA
m_rotx LABEL DWORD  ; 30 degree
    DD 1.0,   0.0,   0.0,   0.0
    DD 0.0,   0.866, 0.5,   0.0
    DD 0.0,  -0.5,   0.866, 0.0
    DD 0.0,   0.0,   0.0,   1.0
m_roty LABEL DWORD  ; 45 degree
    DD 0.707, 0.0,  -0.707, 0.0
    DD 0.0,   1.0,   0.0,   0.0
    DD 0.707, 0.0,   0.707, 0.0
    DD 0.0,   0.0,   0.0,   1.0
m_rotz LABEL DWORD  ; -60 degree
    DD 0.5,  -0.866, 0.0,   0.0
    DD 0.866, 0.5,   0.0,   0.0
    DD 0.0,   0.0,   1.0,   0.0
    DD 0.0,   0.0,   0.0,   1.0
m_trans LABEL DWORD ; (-12.5,460, 12.3)
    DD 1.0,   0.0,   0.0,   0.0
    DD 0.0,   1.0,   0.0,   0.0
    DD 0.0,   0.0,   1.0,   0.0
    DD -12.5, 460.0, 12.3,  1.0

m_tmp     DD 4*4 DUP(?)
m_world   DD 4*4 DUP(?)

local_pts LABEL DWORD
    DD  2.48, -7.53,  3.45, 1.0
    DD  9.23,  0.78, -5.68, 1.0
    DD -4.36,  8.65,  1.56, 1.0
    DD  3.95, -1.23, -2.76, 1.0
    DD -8.12,  2.44,  3.01, 1.0
    DD  1.79,  8.79, -3.56, 1.0
    DD -3.67, -0.98,  7.34, 1.0
    DD  9.51, -4.37, -0.54, 1.0
    DD -1.46,  4.84,  1.95, 1.0
    DD  5.12, -8.35, -2.83, 1.0

world_pts DD NUM_POINTS*4 DUP(?)

; Multiples two matrices
; (res,m0,m1) <ax,bx,cx,si,di,flags,res>
CONCAT MACRO res, m0, m1
    LOCAL row_loop, col_loop

    mov  bx, OFFSET res
    mov  si, OFFSET m0
    mov  di, OFFSET m1

    mov  ax, 4
row_loop:

    mov  cx, 4
col_loop:
    fld  DWORD PTR [si]
    fmul DWORD PTR [di]

    fld  DWORD PTR [si+4]
    fmul DWORD PTR [di+16]
    fadd

    fld  DWORD PTR [si+4*2]
    fmul DWORD PTR [di+16*2]
    fadd

    fld  DWORD PTR [si+4*3]
    fmul DWORD PTR [di+16*3]
    fadd

    fstp DWORD PTR [bx]

    add  bx, 4
    add  di, 4

    loop col_loop

    add  si, 16
    mov  di, OFFSET m1

    dec  ax
    cmp  ax, 0
    jnz  row_loop

    fwait
ENDM

; Multiplies a vector and a matrix
; (res,vec,mat) <ax,bx,cx,si,di,flags,res>
TX MACRO res, vec, mat
    LOCAL loop_col

    mov  bx, OFFSET res
    mov  si, OFFSET vec
    mov  di, OFFSET mat

    mov  cx, 4
loop_col:
    fld  DWORD PTR [si]
    fmul DWORD PTR [di]

    fld  DWORD PTR [si+4]
    fmul DWORD PTR [di+16]
    fadd

    fld  DWORD PTR [si+4*2]
    fmul DWORD PTR [di+16*2]
    fadd

    fld  DWORD PTR [si+4*3]
    fmul DWORD PTR [di+16*3]
    fadd

    fstp DWORD PTR [bx]

    add bx, 4
    add di, 4

    loop loop_col

    fwait
ENDM

.CODE
.STARTUP
    finit

    CONCAT m_world, m_rotx,  m_roty
    CONCAT m_tmp,   m_world, m_rotz
    CONCAT m_world, m_tmp,   m_trans

    TX world_pts[0], local_pts[0], m_world
    TX world_pts[1], local_pts[1], m_world
    TX world_pts[2], local_pts[2], m_world
    TX world_pts[3], local_pts[3], m_world

    mov ah, 4Ch
    xor al, al
    int 21h
END