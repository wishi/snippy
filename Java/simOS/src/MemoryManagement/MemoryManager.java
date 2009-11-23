/*
 * MemoryManager.java
 *
 * Created on September 1, 2007, 12:31 PM
 *
 */

package MemoryManagement;

import Hardware.MainMemory;
import MainBoot.SysLogger;
import java.io.*;

public class MemoryManager implements MemoryManagerIF{
  
  MainMemory memory;
  int nextFree;
  
  /** Creates a new instance of MemoryManager */
  public MemoryManager( MainMemory memory ) {
      this.memory = memory;
      nextFree = 0;
  }
  
  public int loadProgram( String file, PCB pcb ){
    try {
      BufferedReader input = new BufferedReader( new FileReader(file) );
      String line = input.readLine();
      int size = 0;
      if( line != null ) {
        // In der ersten Zeile steht der benötigte Speicherplatz.
        size = Integer.valueOf( line );
        SysLogger.writeLog( 0, "MemoryManager.loadProgram: " + file + " at address " + nextFree + " with size " + size );
        
        // TBD: Prüfen, ob das Programm noch in den Speicher passt.
        
        pcb.getRegisterSet().setBase( nextFree );
        pcb.getRegisterSet().setLimit( nextFree + size - 1 );
        pcb.getRegisterSet().setProgramCounter( 0 );

        int n = nextFree;
        line = input.readLine();
        while (line != null){
          //Debug:  
          //line = input.readLine();
          memory.setContent( n,line );
          n++;
          line = input.readLine();
        }
      }
      input.close();
      nextFree += size;
      
    } catch( IOException e ) {
      System.err.println(e.toString());
      System.exit(1);
    }
    
    return 0;
  }
  
  
}
