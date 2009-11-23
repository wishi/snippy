package MainBoot;
import MemoryManagement.*;
import Scheduler.*;
import Hardware.*;
import java.io.*;

public class BootLoader {
  static int memSize = 100000;
  
  static public class ShutdownException extends Exception{};
  
  public static void main(String [] args) throws IOException {
    SysLogger.openLog();
    /* Die Instanzen fuer die verschiedenen Programmteile werden hier erzeugt
     * und durchgereicht. */
    MainMemory memory = new MainMemory( memSize );
    MMU mmu = new MMU( memory ); // Nur die MMU hat Zugriff auf den Hauptspeicher
    CPU cpu = new CPU( mmu );
    MemoryManagerIF memoryManager = new MemoryManager( memory );
    ProcessManager processManager = new ProcessManager( memoryManager );
    SchedulerIF scheduler = new Scheduler( cpu, processManager );
    processManager.setScheduler( scheduler );
    
    cpu.setProcessManager( processManager );
    cpu.setScheduler( scheduler );
    
    int pid = processManager.createProcess("init");
    SysLogger.writeLog( 0, "BootLoader: initial process created, pid: " + pid );

    SysLogger.writeLog( 0, "BootLoader: starting the cpu" );
    try {
      cpu.operate();
    } catch( ShutdownException x ) {
      SysLogger.writeLog( 0, "BootLoader: shutting down" );
      processManager.destroyProcess(pid);
      SysLogger.closeLog();
    }
  }
}
