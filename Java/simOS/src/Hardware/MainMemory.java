/*
 * SimpleMainMemory.java
 *
 * Created on September 1, 2007, 12:28 PM
 *
 */

package Hardware;
import java.util.ArrayList;

public class MainMemory {
  
  private ArrayList<String> memory = new ArrayList<String>();  
  private int size;
  
  /** Creates a new instance of SimpleMainMemory */
  public MainMemory( int size ) {
    this.size = size;
    for( int i = 0; i < size; i++ ) {
      memory.add( "" );
    }
  }
  
  public String getContent( int address ){
    return memory.get(address);
  }
  
  public void setContent( int address, String value ){
    memory.set( address, value );
  }
  
  public int getSize() {
    return size;
  }

}
