#--------------------------------------------------------------------------
#  Makefile
#
#  Copyright (C) 2024, Bert Lange
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation; either version 2, or (at your option) any
#  later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License 
#  along with this library; see the file COPYING. If not, write to the
#  Free Software Foundation, 51 Franklin Street, Fifth Floor, Boston,
#   MA 02110-1301, USA.
#
#  As a special exception, if you link this library with other files,
#  some of which are compiled with SDCC, to produce an executable,
#  this library does not by itself cause the resulting executable to
#  be covered by the GNU General Public License. This exception does
#  not however invalidate any other reasons why the executable file
#   might be covered by the GNU General Public License.
#--------------------------------------------------------------------------

SRC_C = $(wildcard *.c)
OBJ_C = $(SRC_C:%.c=%.rel)

SRC_ASM = $(wildcard *.s)
OBJ_ASM = $(SRC_ASM:%.s=%.rel)


all: printf.lib
	cp $< ..
	cp printf.h ..

%.rel: %.s
	@echo -n "Assemble: "
	sdasz80  -plsgff  -o  $@ $<

%.rel: %.asm
	@echo -n "Assemble: "
	sdasz80  -plsgff  -o  $@ $<

%.asm: %.c
	@echo -n "Compile: "
	sdcc     -mz80  --fomit-frame-pointer       -Wall  -S   $<   -o $@

%.lib: $(OBJ_ASM) $(OBJ_C)
	@echo -n "Library: "
	sdar  -rc $@    $^


clean:
	rm -f *.sym
	rm -f *.lst
	rm -f *.rel
