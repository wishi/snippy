/*
 * ProcessManagment.java
 *
 * Created on September 1, 2007, 12:28 PM
 *
 */

package MemoryManagement;
import java.util.Hashtable;
import Scheduler.SchedulerIF;
import Hardware.SysConsole;
import MainBoot.SysLogger;

public class ProcessManager {
  
  SchedulerIF scheduler;
  MemoryManagerIF memoryManager;
  
  Hashtable<Integer, PCB> PCBTable = new Hashtable<Integer, PCB>();
  int pidCounter = 0;
  
  static final int initPid = 1;
  
  /** Creates a new instance of ProcessManagment */
  public ProcessManager( MemoryManagerIF memoryManager ) {
    this.memoryManager = memoryManager;
  }
  
  public void setScheduler( SchedulerIF scheduler ) {
    this.scheduler = scheduler;
  }
  
  public int createProcess( String file ) {
    pidCounter++; // PID 0 ist reserviert für den Idle-Prozess
    int priority = 0;
    String state = "fresh";
    
    PCB pcb = new PCB( pidCounter, priority, state );
    memoryManager.loadProgram( file, pcb );
    if( pidCounter != initPid ) {
      // Der neue Prozess erbt die Konsole seines Erzeugers
      int parentPid = scheduler.getRunningPid();
      PCB parent = PCBTable.get( parentPid );
      SysConsole parentConsole = parent.getRegisterSet().getConsole();
      pcb.getRegisterSet().setConsole( parentConsole );
      parentConsole.incRefCount();
    }
    // Einfügen in die PCB Tabelle
    PCBTable.put( pidCounter, pcb );
    SysLogger.writeLog( 0, "ProcessManagment.createProcess: " + pcb.toString() );
    // Beim Scheduler anmelden
    scheduler.addProcess( pcb );
    return pidCounter;
  }
  
  public void destroyProcess( int pid ){
    PCB pcb = PCBTable.get( pid );
    SysLogger.writeLog( 0, "ProcessManagment.destroyProcess: " + pcb.toString() );
    // Falls der Prozess eine Konsole hatte, wird diese nun zerstört
    SysConsole console = pcb.getRegisterSet().getConsole();
    if( console != null ) {
      console.decRefcount();
      if( console.zeroRefCount() ) {
        SysLogger.writeLog( 0, "ProcessManagment.destroyProcess: destroying console " + console.getId() );
	console.dispose();
      }
    }
    PCBTable.remove(pid);
  }
  
}
