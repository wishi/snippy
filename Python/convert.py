#!/usr/bin/env python

"""
just some base conversions 
@WRK
"""

def useage():
    print "-c             Base-converts Integer values. Automatically: 0x - hex, 0 - oct."
    print "-d2h           decimal to hexadecimal"
    print "-d2o           decimal to octal"
    print "-d2b           decimal to binary"
    print "-d x           specify x as base number to convert into from decimal"
    print "-h x           specify x as base number to convert into from hexadecimal"
    print "-o x           specify x as base number to convert into from octal"
    print "-b x           specify x as base number to convert into from binary"
    

def bin_to_hex(number):
    # @TODO   
    print "b2h"   # note: immer 8, dann ein Leerzeichen               
    
def dec_to_hex(number):
    print "Out:" + "hex   %X" % number
  
def hex_to_dec(aString):
    return int(aString, 16)

def oct_to_dec(aString):
    return int (aString, 8)

if __name__ == '__main__':
    import sys

    input = sys.argv[2]
    print "In        " + input
    
    # in this case we're dealing with hex
    if ( input.startswith("0x") or input.startswith("0X") ):
        print hex_to_dec(input)
    elif ( input.startswith("0") ):
        print oct_to_dec(input)
    else:
        dec_to_hex(int(input))       
    
   
    
   
   
    
