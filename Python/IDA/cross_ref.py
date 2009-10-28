"""
finds potencially vulnerable functions in binaries

@DEPS:
   * IDA >= 4.9 (http://www.hex-rays.com/idapro/idadown.htm)
   * IDAPython http://d-dome.net/idapython/,
               http://code.google.com/p/idapython/downloads/list
   * Python >= 2.5

- cross_ref is by Justin Seitz from Gray Hat Python. 
All changes made a fairly trivial ;)  
- depending on your target you can go after MS SDL baned functions
(http://msdn.microsoft.com/en-us/library/bb288454.aspx)
- tested against Macho and PE on MacOS and Windoh
  will only work if functions names can be resolved -> FLIRT

-- wishi
"""

from idaapi import *

danger_funcs = ["_strcpy", "_sprintf", "_memcpy"] # add more depending on your read

for func in danger_funcs:
   addr = LocByName( func )
   if addr != BADADDR:
      cross_refs = CodeRefsTo( addr, 0 )
      # grab cross-references to this address
      print "Cross References to %s" %func
      print "----------------------------"
      for ref in cross_refs:
         print "%08x" %ref
         # color the call red
         SetColor( ref, CIC_ITEM, 0x0000ff)


