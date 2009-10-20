/*
 * This sample code retrieves the old value of the
 * r3 register and sets it to 0xdeadbeef.
 *
 * - nemo
 *
 * ported to Leopard... sets r3 = EAX 
 * by FG
 * 
 * uses __eax due a relatively recent change 
 * - wishi
 *
 * REF:
 * http://www.uninformed.org/?v=4&a=3
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <mach/mach_types.h>
#include <mach/i386/thread_status.h>


void 
error(char *msg)
{
   printf("[!] error: %s.\n", msg);
   exit(1);
} // -- end of error() 


int 
main(int ac, char **av)
{
        
   i386_thread_state_t i386_state;
   mach_msg_type_number_t sc = i386_THREAD_STATE_COUNT;
   long thread = 0;        // for first thread
   thread_act_port_array_t thread_list;
   mach_msg_type_number_t thread_count;
   task_t port;
   pid_t  pid;

   if(ac != 2) {
      printf("usage: %s <pid>\n",av[0]);
      exit(1);
   }

   pid = atoi(av[1]);

   if(task_for_pid(mach_task_self(), 
            pid, 
            &port))
      error("cannot get port");

   // better shut down the task while we do this.
   if(task_suspend(port)) 
      error("suspending the task");

   if(task_threads(port, 
            &thread_list, 
            &thread_count))
      error("cannot get list of tasks");


   if(thread_get_state(
         thread_list[thread],
         i386_THREAD_STATE,
         (thread_state_t)&i386_state,
         &sc)) 
      error("getting state from thread");

    printf("old r3: 0x%x\n",i386_state.__eax);

    i386_state.__eax = 0x01;

    if(thread_set_state(
         thread_list[thread],
         i386_THREAD_STATE,
         (thread_state_t)&i386_state,
         sc))
      error("setting state");

    if(task_resume(port)) 
       error("cannot resume the task");

    return 0;

} // -- end of main()
// EOF
