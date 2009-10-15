/*  Marius Ciepluch
 *  
 *  Ein einfaches Unix API Beispiel 
 *  fürs Listen von Files im aktiven
 *  Verzeichnis.
 *
 *  Achtung: POSIX lib wurde NICHT benutzt!
 *  http://www.opengroup.org/onlinepubs/007908775/xsh/unistd.h.html
 *
 *  Ref:
 *  http://opengroup.org/onlinepubs/007908799/xsh/opendir.html
 *  http://libslack.org/manpages/snprintf.3.html
 *
 *  Dependencies: glibc > 2
 * */ 

#include <stdio.h>   
#include <stdlib.h>   
#include <dirent.h>              // wichtige Includes

#include <unistd.h>	  

// inkonsistent durch GNU C Standard: 
typedef int bool;

#define TRUE   (1)
#define FALSE  (0)


int 
main(void){   
             
   DIR *directory;               // DIR Typ
   struct dirent *entry;         
   
   bool done = FALSE;
   
   char dir[1024], *s;
   char string[256]; 

  	s = getwd(dir);               // holt _w_orking _d_irectory 
   directory = opendir(s);       // oeffnet wd, hier s
      if (directory != 0)        // sofern wd vorhanden
      {
         while (!done)           
         {
            entry = readdir(directory);
            if (entry != 0)      // fall kein File da
            {	
               if ((strncmp(entry->d_name, ".", 1) != 0))       
                        // es wird nur der erste Letter verglichen
                        // ist es ein . wird es uebergangen (default)
               {
                  int len = snprintf(NULL, 0, "%s/%s", s, entry->d_name);
                  snprintf(string, len, "%s/%s", s, entry->d_name); 
                  // es wird snprintf benutzt um hier einen Stackbuffer-
                  // overflow zu vermeiden. 
                  printf("%s \n", string);
               }	
            }
            else
            {	
               done = TRUE;		
            }	
         }
      }
      closedir(directory);
      return 1;
      exit(0);
}
