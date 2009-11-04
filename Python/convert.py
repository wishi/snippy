#!/usr/bin/env python

"""
just some base conversions 
@WRK
"""

def useage():
    print "-c             Base-converts Integer values. Automatically: 0x - hex, 0 - oct..."
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

def bin_to_dec(aString):
    return int (aString, 2)

if __name__ == '__main__':
    import sys
    import getopt # @TODO
            
    
    input = sys.argv[2]
    print "In        " + input
    
    """
    0x, 0, 0b - hex, oct, bin
    default is to decimal
    """
    if sys.argv[1]=="-c":
        if ( input.startswith("0x") or input.startswith("0X") ):
            print hex_to_dec(input)
        elif ( input.startswith("0") ):
            print oct_to_dec(input)
        elif ( input.startswith("0b") ):
            print bin_to_dec(input)
     
    if sys.argv[1]=="-d2h":
        dec_to_hex(int(input))
    
    if sys.argv[1]=="-d2o":
        
        
   
    
   
   
    
