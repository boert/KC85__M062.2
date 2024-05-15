//--------------------------------------------------------------------------
//  main.c
//
//  Copyright (C) 2024, Bert Lange
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the
//  Free Software Foundation; either version 2, or (at your option) any
//  later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this library; see the file COPYING. If not, write to the
//  Free Software Foundation, 51 Franklin Street, Fifth Floor, Boston,
//   MA 02110-1301, USA.
//
//  As a special exception, if you link this library with other files,
//  some of which are compiled with SDCC, to produce an executable,
//  this library does not by itself cause the resulting executable to
//  be covered by the GNU General Public License. This exception does
//  not however invalidate any other reasons why the executable file
//   might be covered by the GNU General Public License.
//--------------------------------------------------------------------------


#include <stdio.h>
#include <stdint.h>
#include "caos.h"

// Prototypen

// Speicherstellen
volatile __at (0xB7A0) uint8_t IRM_CURSO;
volatile __at (0xB7A2) uint8_t IRM_STBT;
volatile __at (0xB7A3) uint8_t IRM_COLOR;
volatile __at (0xB800) uint8_t IRM_MODST[256];

// Hilfskonstanten
const uint8_t mod_off = 0;
const uint8_t mod_ro = 1;
const uint8_t mod_rw = 3;

const char filename_seg0[] = "M062SEG0.KCC";
const char filename_seg1[] = "M062SEG1.KCC";
const char filename_seg2[] = "M062SEG2.KCC";
const char filename_seg3[] = "M062SEG3.KCC";

// Hilfsfunktionen
#define hi(x)   ((x) >> 8)
#define lo(x)   ((x) & 0xff)


uint8_t modul_search( const uint8_t struct_byte)
{
    uint8_t slot;
    uint16_t value;

    for( slot = 8; slot < 255; slot++)
    {
        value = modu( 1, slot, 0);
        if( hi( value) == struct_byte)
        {
            return slot;
        }
    }
    return 0;
}


void main( void)
{
    uint8_t ram4_state;
    uint8_t segment;
    uint8_t m062_slot;

    m062_slot = modul_search( 0xF3);
    ram4_state = IRM_MODST[4];

#if 0
    // Debug
    printf( "M062 slot: %02X\n", m062_slot);
    printf( "RAM4 state: %02X\n", ram4_state);
#endif

    if( m062_slot > 0)
    {
        printf( "M062.2 (32k-RAM-Version)\nin Schacht %02X bef\x7dllen\n", m062_slot);
    }
    else
    {
        printf( "Modul M062 nicht gefunden.\n");
        return;
    }

    printf( "RAM 4 abschalten\n");
    modu( 2, 4, mod_off);


    printf( "Segment 0...");
    segment = 0;
    modu( 2, m062_slot, 0x40 + (segment << 2) + mod_rw);
    load( filename_seg0);


    printf( "Segment 1...");
    segment = 1;
    modu( 2, m062_slot, 0x40 + (segment << 2) + mod_rw);
    load( filename_seg1);


    printf( "Segment 2...");
    segment = 2;
    modu( 2, m062_slot, 0x40 + (segment << 2) + mod_rw);
    load( filename_seg2);


    printf( "Segment 3...");
    segment = 3;
    modu( 2, m062_slot, 0x40 + (segment << 2) + mod_rw);
    load( filename_seg3);


    printf( "M062 deaktivieren\n");
    modu( 2, m062_slot, mod_off);


    printf( "RAM 4 zur\x7dcksetzen\n");
    modu( 2, 4, ram4_state);

    return;
}
