#include <stdio.h>

// put the shellcode in here, compile and and diassemble
unsigned char shellcode[] = "\x00\x02";

void 
main() {
   
   void (*c)();
   //printf("Hello shellcode!\n");
   
   *(int*)&c = shellcode;
   c();
}

