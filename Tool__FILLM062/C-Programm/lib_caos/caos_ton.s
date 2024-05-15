; some functions provided by the CAOS (=monitor program)

; first parameter LSB on SP+2
; first parameter MSB on SP+3
; 2nd   parameter LSB on SP+4
; 2nd   parameter MSB on SP+5
; return values on L or HL

    .include 'caos.inc'



; Zeichnen eines Kreises mit dem eingestellten Linientyp
; auf dem Bildschirm mit Mittelpunkt XM/YM und Radius R
; in:
;   (ARG1)   - Tonhöhe 1, rechts 
;   (ARG1+1) - Vorteiler 1 
;   (ARG2)   - Tonhöhe 2, links
;   (ARG2+1) - Vorteiler 2
;   (ARG3)   - Lautstärke
;   (ARG3+1) - Tondauer
.globl _ton
_ton::
    ld  hl, #2
    add hl, sp
    ld  de, #ARG1
    ld  bc, #6
    ldir
    call PV1
    .db FNTON
    ret
