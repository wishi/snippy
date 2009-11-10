// just something to test on Linux

#include <unistd.h>

int main(int argc, char **argv[]) {

char *execve_argv[] = {
              NULL
         };

if (execve("/usr/bin/su", execve_argv, NULL) != 0) {
   perror("error executing su");
   }
}

