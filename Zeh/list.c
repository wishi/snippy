/**  
 *  @AUTHOR: 
 *  Marius Ciepluch
 *
 *  @INFO: 
 *  Ein einfaches Unix API Beispiel fürs Listen von Files im aktiven
 *  Verzeichnis. Versteckte Dateien werden ignoriert.
 *  
 *  @MISC:
 *  http://www.opengroup.org/onlinepubs/007908775/xsh/unistd.h.html
 *
 *  @REF_LINKS:
 *  http://opengroup.org/onlinepubs/007908799/xsh/opendir.html
 *  http://libslack.org/manpages/snprintf.3.html
 *  http://www.opengroup.org/onlinepubs/009695399/functions/getcwd.html
 *
 *  @DEPS:
 *  glibc > 2        -  wegen snprintf return
 *  GNU C            -  weil nicht für M$ 
 *                      Unix-artiges OS
 *                   
 **/ 

#include <stdio.h>   
#include <stdlib.h>   

#include <dirent.h>              // wichtige Includes
#include <unistd.h>	  


// inkonsistent durch GNU C Standard (kein Bool): 
typedef int bool;

#define TRUE   (1)
#define FALSE  (0)


int 
main(void)
{   
             
   DIR *directory;               // DIR Typ
   struct dirent *entry;         
   
   bool done = FALSE;
   
   char *buf, *ptr;
   unsigned long size;
   char string[256];             // wird speziell behandelt

   size = (unsigned long)(pathconf(".", _PC_PATH_MAX));
   
   if ((buf = (char *) malloc((size_t)size)) != NULL)
      ptr = getcwd(buf, (size_t)size);
   
   directory = opendir(ptr);       // oeffnet wd
     
   if (directory != 0)           // sofern wd vorhanden
   {
      while (!done)           
      {
         entry = readdir(directory);
         
         if (entry != 0)      // falls kein File da
         {	
            
            // es wird nur der erste Letter verglichen
            // ist es ein . wird es uebergangen (default)
            if ((strncmp(entry->d_name, ".", 1) != 0))       
            {
               // Länge ermitteln
               size_t len = snprintf(NULL, 0, "%s/%s", ptr, entry->d_name);
               len=len+3;
               
               // es wird snprintf benutzt um hier einen Stackbuffer-
               // overflow zu vermeiden. 
               (void)snprintf(string, len, "%s/%s", ptr, entry->d_name); 
               printf("%s \n", string);
            }	
         }
         else
         {	
            done = TRUE;		
         }  	
      } // -- end of while
   } 
   closedir(directory);
   free (buf);

   return 1;      // formal return
   exit(0);      // clean exit

} // -- end of main
// EOF
