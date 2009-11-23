/*
 * MMU.java
 *
 * Created on 16. Dezember 2007, 17:00
 *
 */

package Hardware;

import MainBoot.SysLogger;

public class MMU {
  private MainMemory memory;
  private RegisterSet regSet;

  static public class AccessViolation extends Exception{};
  
  /** Creates a new instance of MMU */
  public MMU( MainMemory memory ) {
    this.memory = memory;
  }
  
  public void setRegisterSet( RegisterSet regSet ) {
    this.regSet = regSet;
  }
  
  public void setMemoryCell( String address, String value ) throws AccessViolation {
    setMemoryCell( Integer.parseInt(address), value );
  }

  public void setMemoryCell( int address, String value ) throws AccessViolation {
    if( address < 0 || address > regSet.getLimit() ) {
      SysLogger.writeLog( 0, "MMU.setMemoryCell: access violation: " + address );
      throw new AccessViolation();
    }
    int realAddress = address + regSet.getBase();
    memory.setContent( realAddress, value );
  }
  
  public void setAbsoluteAddress( int address, String value ) {
    memory.setContent( address, value );
  }
  
  public int resolveAddress( String address ) throws AccessViolation {
    return resolveAddress( Integer.parseInt(address) );
  }
  
  public int resolveAddress( int address ) throws AccessViolation {
    if( address < 0 || address > regSet.getLimit() ) {
      SysLogger.writeLog( 0, "MMU.resolveAddress: access violation: " + address );
      throw new AccessViolation();
    }
    return address + regSet.getBase();
  }
  
  public String getMemoryCell( String address ) throws AccessViolation {
    return getMemoryCell( Integer.parseInt(address) );
  }

  public String getMemoryCell( int address ) throws AccessViolation {
    if( address < 0 || address > regSet.getLimit() ) {
      SysLogger.writeLog( 0, "MMU.getMemoryCell: access violation: " + address );
      throw new AccessViolation();
    }
    int realAddress = address + regSet.getBase();
    return memory.getContent( realAddress );
  }
  
  public void dumpMemory( int limit ) {
    SysLogger.writeLog( 1, "MMU.dumpMemory" );
    for( int i = 0; i < limit; i++ ) {
      SysLogger.writeLog( 1, i + ": " + memory.getContent(i) );
    }
  }

}
