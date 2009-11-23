package Hardware;

import MainBoot.SysLogger;
import Scheduler.Event;
import javax.swing.*;
import java.awt.event.*;
import java.util.*;

public class IO {
  ArrayList<Event> readList;
  ArrayList<Event> resultQueue;
  int consoleId;
  
  public IO() {
    readList = new ArrayList<Event>();
    resultQueue = new ArrayList<Event>();
    consoleId = 0;
  }
  
  public SysConsole createConsole( String title ) {
    consoleId++;
    SysLogger.writeLog( 0, "IO.createConsole: new console [id: " + consoleId + ", title: " + title + "]" );
    SysConsole frame = new SysConsole( this, consoleId, title );
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.setSize( 475, 400 );
    frame.setVisible(true);
    return frame;
  }
  
  public void write( SysConsole console, String text ) {
    console.write( text );
  }
  
  public void writeln( SysConsole console ) {
    console.write( "\n" );
  }
  
  public void read( Event event ) {
    SysLogger.writeLog( 0, "IO.read: adding event to read queue " + event.toString() );
    readList.add( event );
  }
  
  public void receiveReadContent( int consoleId, String text ) {
    SysLogger.writeLog( 0, "IO.receiveReadContent: received: '" + text + "' from console " + consoleId );
    Event event = null;
    // Die empfangene Zeichenfolge wird in ein zugehöriges Event eingetragen.
    // Unter allen Events für dieselbe Konsole wird das jüngste ausgewählt.
    for( int i = readList.size()-1; i >= 0;  i-- ) {
      if( readList.get(i).getConsole().getId() == consoleId ) {
	event = readList.remove(i);
	break;
      }
    }
    if( event != null ) {
      event.setContent( text );
      SysLogger.writeLog( 0, "IO.receiveReadContent: adding event to result queue " + event.toString() );
      resultQueue.add( event );
    }
  }
  
  public Event getNextEvent() {
    return resultQueue.size() > 0 ? resultQueue.remove(0) : null;
  }
  
}

