//--------------------------------------------------------------------------
//  caos.h
//
//  Copyright (C) 2015-2024, Bert Lange
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


/*
 * realisierte Funktionen:
 crt
 kbd
 kbds
 bye
 kbdz
 colorup
 load
 loop
 wait
 inlin
 errm
 hlhx
 hlde
 ahex
 cucp
 modu
 jump
 brkt
 space
 crlf
 home
 pude
 puse
 winin
 winak
 line
 circle
 sqr
 cstbt
 iniea
 inime
 zkout
 OSTR
 ton
 */

//////////////////////////
// Z80 common functions
//////////////////////////
extern unsigned char in( unsigned char port) __sdcccall(0);
extern void          out( unsigned char port, unsigned char value) __sdcccall(0);
extern unsigned char in16( unsigned int port) __sdcccall(0);
extern void          out16( unsigned int port, unsigned char value) __sdcccall(0);
extern unsigned char reg_r( void) __sdcccall(0);
extern void          test_ix( void) __sdcccall(0);


//////////////////////////
// KC85 IO definitions
//////////////////////////
__sfr __at 0x84 IO84H;      // IRM control, RAM8 bank sel
__sfr __at 0x86 IO86H;      // RAM4 bank, ROMC bank, CAOS ROMC

__sfr __at 0x88 PIOA_DATA;
__sfr __at 0x89 PIOB_DATA;
__sfr __at 0x8A PIOA_CTRL;  // ROME, RAM0, IRM, Keyboard, LED, ROMC
__sfr __at 0x8B PIOB_CTRL;  // Lautstärke, RAM8, blinken

__sfr __at 0x8C CTC0;
__sfr __at 0x8D CTC1;
__sfr __at 0x8E CTC2;
__sfr __at 0x8F CTC3;

__sfr __at 0x90 PIOJOY_DATA;
__sfr __at 0x91 PIOCEN_DATA;
__sfr __at 0x92 PIOJOY_CTRL;  // Joystick (M021)
__sfr __at 0x93 PIOCEN_CTRL;  // Drucker (M021)

__sfr __at 0x28 PIONETA_DATA;
__sfr __at 0x29 PIONETB_DATA;
__sfr __at 0x2a PIONETA_CTRL;
__sfr __at 0x2b PIONETB_CTRL;

__sfr __at 0x2c PIOUSBA_DATA;
__sfr __at 0x2d PIOUSBB_DATA;
__sfr __at 0x2e PIOUSBA_CTRL;
__sfr __at 0x2f PIOUSBB_CTRL;


//////////////////////////
// KC85 color definitions
//////////////////////////
#define BLACK   ( 0)
#define BLUE    ( 1)
#define RED     ( 2)
#define PURPLE  ( 3)
#define GREEN   ( 4)
#define CYAN    ( 5)
#ifndef YELLOW
#define YELLOW  ( 6)
#endif
#ifndef WHITE
#define WHITE   ( 7)
#endif

// KC85 character define
#define CLR     ( 0x01)
#define CLL     ( 0x02)
#define BREAK   ( 0x03)
#define BEEP    ( 0x07)
#define CUL     ( 0x08)
#define CUR     ( 0x09)
#define CUD     ( 0x0a)
#define CUU     ( 0x0b)
#define CLS     ( 0x0c)
#define CR      ( 0x0d)
#define PAGE    ( 0x11)
#define SCROL   ( 0x12)
#define STOP    ( 0x13)
#define CEL     ( 0x18)
#define CCR     ( 0x19)
#define ESC     ( 0x1b)
#define DEL     ( 0x1f)

//////////////////////////
// dont use colon (:) in OSTR, this gives assembler error
// (mabye a wrong construct with label or so)
#define OSTR( X) \
    __asm__( "call 0xf003"); \
    __asm__( ".db 0x23 ;OSTR"); \
    __asm__( ".asciz "#X"");


//////////////////////////
// KC85/CAOS specific functions
//////////////////////////


/*
 * Zeichenausgabe auf Bildschirm
 */
extern void crt( unsigned char) __sdcccall(0);


/*
 * Tasteneingabe mit Einblendung des Cursors, 
 * wartet, bis Taste gedrückt bzw. liefert die 
 * Codefolge von vorher betätigter F-Taste
 * out:
 *   high - Taste
 *   low  - 1, Taste gedrückt
 */
extern unsigned char kbd( void) __sdcccall(0);


/*
 * Tastenstatusabfrage ohne Quittierung 
 * der Taste
 *  high byte = Taste
 *  low byte  = 1, Taste gedrückt
 */
extern unsigned int kbds( void) __sdcccall(0);


/*
 * Sprung auf RESET (Warmstart des Systems)
 */
extern void bye( void) __sdcccall(0);


/*
 * Tastenstatusabfrage mit Quittierung 
 * der Taste (Autorepeat)
 *  high byte = Taste
 *  low byte  = Bit 0, Taste gedrückt
 */
extern unsigned int kbdz( void) __sdcccall(0);


/*
 * Farbe einstellen
 */
extern void colorup( unsigned char argn, unsigned char foreground, unsigned char background) __sdcccall(0);


/*
 * Laden einer Datei
 * Register HL: Zeiger auf Dateiname
 * ARGN = 0: ohne OFFSET
 * ARGN = 1: mit OFFSET (ARG1)
 * ARGN = 2: Autostart unterdrücken
 */
extern void load( unsigned char*) __sdcccall(0);


/*
 * Rückgabe der Steuerung an CAOS ohne Speicherinitialisierung
 */
extern void loop( void) __sdcccall(0);


/*
 * Warteschleife (tick = 6 ms)
 */
extern void wait( unsigned char t) __sdcccall(0);


/*
 * Eingabe einer Zeile mit Funktion aller Cursortasten, 
 * Abschluss mit <ENTER> oder Abbruch <BRK>
 *
 *  Zeiger auf Adresse des Zeilenanfangs des eingestellten Fensters im Video-RAM
 */
extern char* inlin( void) __sdcccall(0);


/*
 * Ausschrift des Textes „ERROR“
 */
extern void errm( void) __sdcccall(0);


/*
 * Ausgabe des Wertes des Registers HL als Hexzahl
 * und danach ein Leerzeichen
 */
extern void hlhx( unsigned int) __sdcccall(0);


/*
 * Ausgabe der Register HL und DE als Hexzahlen
 */
extern void hlde( unsigned int, unsigned int) __sdcccall(0);


/*
 * Ausgabe Register A als Hexzahl
 */
extern void ahex( unsigned char) __sdcccall(0);


/*
 * Komplementiere Cursor
 */
extern void cucp( void) __sdcccall(0);


/*
 * Modulsteuerung
 *   = Lesen des Modultyps (anzahl < 2)
 *   = Aussenden des Steuercodes (anzahl ≥ 2)
 * out:
 *   high - Modultyp (Strukturbyte)
 *   low  - Modulsteuerbyte
 */
extern unsigned int modu( unsigned char anzahl, unsigned char steckplatz, unsigned char steuerbyte) __sdcccall(0);


/*
 * Sprung in ein neues Betriebssystem, 
 *  Abschalten von CAOS-ROM, USER-ROM und aller Speichermodule.
 */
extern void jump( unsigned char modulsteckplatz) __sdcccall(0);


/*
 * Test auf Unterbrechungsanforderung
 * out:
 *   high - Taste
 *   low  - 1, wenn BREAK
 *          0, sonst
 */
extern unsigned int brkt( void) __sdcccall(0);


/*
 * Ausgabe eines Leerzeichens über UP-Nr. 24H
 */
extern void space( void) __sdcccall(0);


/*
 * Ausgabe von „NEWLINE“ (Codes 0DH=CR und 0AH=LF)
 */
extern void crlf( void) __sdcccall(0);


/*
 * Ausgabe des Steuerzeichens „HOME“ (Code 10H)
 */
extern void home( void) __sdcccall(0);


/*
 * Löschen eines Bildpunktes
 * MSB = Farbbyte
 * LSB = Status 
 *   Bit 0 (CY) = 1, Punkt außerhalb 
 *   Bit 6 (Z)  = 1, Punkt nicht gesetzt
 */
extern unsigned int pude( unsigned int x, unsigned char y) __sdcccall(0);


/*
 * Setzen eines Bildpunktes
 *
 * Bedeutung von color:
 *   Bit 0 = 1 XOR-Funktion
 *   Bit 1 = 1 Linie löschen
 *   Bit 3 - 7 Farbe (Vordergrund)
 */
extern unsigned int puse( unsigned int x, unsigned char y, unsigned char color) __sdcccall(0);


/*
 * Tonausgabe
 */
extern void ton( unsigned char z1, unsigned char v1, unsigned char z2, unsigned char v2, unsigned char ls, unsigned char td) __sdcccall(0);


/*
 * Initialisierung eines neuen Fensters
 *  in:
 *   Fensternummer
 *   links
 *   oben
 *   Spalten
 *   Zeilen
 *  out:
 *   Bit 0 = 1, Fehler
 */
extern unsigned char winin( unsigned char links, unsigned char oben, unsigned char spalten, unsigned char zeilen, unsigned char nr) __sdcccall(0);


/*
 * Aufruf eines Fensters über seine Nummer 
 * mit Abspeicherung des aktuellen Fenstervektors
 *  in:
 *   Fensternummer
 */
extern unsigned char winak( unsigned char nr) __sdcccall(0);


/*
 * Zeichnen einer Linie mit dem eingestellten Linientyp
 * auf dem Bildschirm von X0/Y0 nach X1/ Y1
 *
 * Bedeutung von color:
 *   Bit 0 = 1 XOR-Funktion
 *   Bit 1 = 1 Linie löschen
 *   Bit 3 - 7 Farbe (Vordergrund)
 */
extern void line( unsigned int x0, unsigned int y0, unsigned int x1, unsigned int y1, unsigned char color) __sdcccall(0);


/*
 * Zeichnen eines Kreises mit dem eingestellten Linientyp
 * auf dem Bildschirm mit Mittelpunkt XM/YM und Radius R
 *
 * Bedeutung von color:
 *   Bit 0 = 1 XOR-Funktion
 *   Bit 1 = 1 Linie löschen
 *   Bit 3 - 7 Farbe (Vordergrund)
 */
extern void circle( unsigned int xm, unsigned int ym, unsigned int r, unsigned char color) __sdcccall(0);


/*
 * Berechnen der Quadratwurzel
 */
extern unsigned char sqr( unsigned int) __sdcccall(0);


/*
 * Berechnung des Produktes zweier 8-Bit-Zahlen
 */
extern unsigned int mult( unsigned char, unsigned char) __sdcccall(0); 


/*
 * Zeichenausgabe mit Negation des Bits 3 des Steuerbytes (STBT) 
 * des Bildschirmprogramms (Ausführung der Steuerzeichen/
 * Abbildung der Steuerzeichen)
 */
extern void cstbt( unsigned char) __sdcccall(0);


/*
 * Initialisieren eines E/A-Kanals ueber Tabelle
 */
extern void iniea( unsigned char* table) __sdcccall(0);


/*
 * Initialisieren mehrerer E/A-Kaenale ueber Tabelle(n)
 */
extern void inime( unsigned char* table, unsigned char count) __sdcccall(0);


/*
 * Ausgabe einer über Register HL adressierten Zeichenkette
 */
extern void zkout( unsigned char*) __sdcccall(0);
