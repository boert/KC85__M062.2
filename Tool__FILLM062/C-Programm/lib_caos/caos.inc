;--------------------------------------------------------------------------
;  caos.inc - definitions on KC85(5)
;
;  Copyright (C) 2024, Bert Lange
;
;  This library is free software; you can redistribute it and/or modify it
;  under the terms of the GNU General Public License as published by the
;  Free Software Foundation; either version 2, or (at your option) any
;  later version.
;
;  This library is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License 
;  along with this library; see the file COPYING. If not, write to the
;  Free Software Foundation, 51 Franklin Street, Fifth Floor, Boston,
;   MA 02110-1301, USA.
;
;  As a special exception, if you link this library with other files,
;  some of which are compiled with SDCC, to produce an executable,
;  this library does not by itself cause the resulting executable to
;  be covered by the GNU General Public License. This exception does
;  not however invalidate any other reasons why the executable file
;   might be covered by the GNU General Public License.
;--------------------------------------------------------------------------



; jump distribution (Sprungverteiler)
PV1       = 0xf003 ; parameter in regs, PVnr after call
PV2       = 0xf006 ; return params in AF, PVnr on ARGC
PV3       = 0xf009 ; like PV2, but PVnr in reg E
PV4       = 0xf00c ; like PV3, but with IRM
PVrel     = 0xf00f ; relavite call
PV5       = 0xf015 ; PV3 with IRM and setting SP to  SYSP
PV6       = 0xf01e ; like PV5, bit PVnr on ARGC
PV7       = 0xf021 ; for disk/usb functions

; system cells
CASS      = 0xb700 ; buffer for tape operations
ARGC      = 0xb780 ; up nr for PV2 and PV6
ARGN      = 0xb781 ; nr of argument
ARG1      = 0xb782 ; argument 1
ARG2      = 0xb784 ; argument 2
ARG3      = 0xb786 ; argument 3
ARG10     = 0xb794 ; argument 10

CURSO_COL = 0xb7a0 ; cursor position x
CURSO_ROW = 0xb7a1 ; cursor position y

STBT      = 0xb7a2 ; control byte for screen
COLOR     = 0xb7a3 ; color byte

HOR       = 0xb7d3 ; horizontal graphic position
VERT      = 0xb7d5 ; vertical graphic position
FARB      = 0xb7d6 ; graphic color
MODST     = 0xb800 ; memory for module control bytes


; functions numbers
FNCRT     = 0x00
FNKBD     = 0x04
FNKBDS    = 0x0c
FNBYE     = 0x0d
FNKBDZ    = 0x0e
FNCOLORUP = 0x0f
FNLOAD    = 0x10
FNLOOP    = 0x12
FNWAIT    = 0x14
FNLARG    = 0x15
FNINLIN   = 0x17
FNERRM    = 0x19
FNHLHX    = 0x1a
FNHLDE    = 0x1b
FNAHEX    = 0x1c
FNOSTR    = 0x23
FNCUCP    = 0x25
FNMODU    = 0x26
FNJUMP    = 0x27
FNBRKT    = 0x2a
FNSPACE   = 0x2b
FNCRLF    = 0x2c
FNHOME    = 0x2d
FNPUDE    = 0x2f
FNPUSE    = 0x30
FNTON     = 0x35
FNWININ   = 0x3c
FNWINAK   = 0x3d
FNLINE    = 0x3e
FNCIRCLE  = 0x3f
FNSQR     = 0x40
FNMULT    = 0x41
FNCSTBT   = 0x42
FNINIEA   = 0x43
FNINIME   = 0x44
FNZKOUT   = 0x45

