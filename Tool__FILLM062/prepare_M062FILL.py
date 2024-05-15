#! /usr/bin/env python3

#--------------------------------------------------------------------------
#  prepare_m062fill.py
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


import sys
import struct


########################################
# helper functions
def build_header( fname):

    output_filename_split = fname.split( '.')
    output_name = output_filename_split[ 0][:8].ljust( 8)
    output_ext  = output_filename_split[ 1][:3].ljust( 3)

    address_args = 2
    load_address = 0x4000
    end_address = 0x6000
    start_address = 0

    kcc_header = bytearray()
    kcc_header.extend( output_name.encode('latin-1'))
    kcc_header.extend( output_ext.encode('latin-1'))
    kcc_header.extend( [ 0] * 5)
    kcc_header.extend( struct.pack( "B", address_args))
    kcc_header.extend( struct.pack( "H", load_address))
    kcc_header.extend( struct.pack( "H", end_address))
    kcc_header.extend( struct.pack( "H", start_address))
    kcc_header.extend( [0] * 105)

    return kcc_header

########################################

args =  len( sys.argv)
if args < 2:
    print( "usage: %s <input.bin>" % sys.argv[ 0])
    exit( 0);


# collect parameter
input_filename = sys.argv[ 1]


# read binary file
with open( input_filename, mode='rb') as original: data = original.read()


# pad or truncate
target_len = 32768
if len( data) < target_len:
    print( "binary to short, fillup to 32k.")

if len( data) > target_len:
    print( "binary to long, crop to 32k!")

data = data[:target_len] + bytes( [0xff]*( target_len - len( data)))


# write files
output_filename = "M062SEG0.KCC"
kcc_header = build_header( output_filename)
print( "write %s" % output_filename)
with open( output_filename, 'wb') as modified: modified.write( kcc_header + data[0:8*1024])

output_filename = "M062SEG1.KCC"
kcc_header = build_header( output_filename)
print( "write %s" % output_filename)
with open( output_filename, 'wb') as modified: modified.write( kcc_header + data[8*1024:16*1024])

output_filename = "M062SEG2.KCC"
kcc_header = build_header( output_filename)
print( "write %s" % output_filename)
with open( output_filename, 'wb') as modified: modified.write( kcc_header + data[16*1024:24*1024])

output_filename = "M062SEG3.KCC"
kcc_header = build_header( output_filename)
print( "write %s" % output_filename)
with open( output_filename, 'wb') as modified: modified.write( kcc_header + data[24*1024:32*1024])
