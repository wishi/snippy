/*
 * =====================================================================================
 *
 *       Filename:  PoC_stackbufferoverflow.c
 *
 *    Description:  the easiest example for a general stack-bufferoverflow in C
 *                   entry-point: argument, commandline
 *                   issue: no input-validation
 *
 *        Version:  1.0
 *        Created:  20.10.2009 18:37:50
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */


void
main(int argc, char* argv[]){

   smash(argv[1]);   // first argument = programm, second = input ;)

} // -- end of main()


void 
smash(char* input){

   char buffer[1024];
   strcpy(buffer, input);

} // -- end of smash()
