; some functions provided by the CAOS (=monitor program)

; first parameter LSB on SP+2
; first parameter MSB on SP+3
; 2nd   parameter LSB on SP+4
; 2nd   parameter MSB on SP+5
; return values on L or HL

    .include 'caos.inc'



; Berechnung des Produktes zweier 8-Bit-Zahlen
.globl _mult
_mult::
    ld hl,#2
    add hl, sp
    ld	d, (hl)
    inc hl
    ld	c, (hl)
    call PV1
    .db FNMULT
    ld  h, b
    ld  l, a
    ret
