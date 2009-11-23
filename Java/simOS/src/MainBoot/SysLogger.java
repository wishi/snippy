package MainBoot;

import java.io.*;

public class SysLogger {
  static int traceFlag = 0;
  static String logFile = "syslog.txt";
  static private BufferedWriter log;

  public static void writeLog( int traceLevel, String message ) {
    try {
      if( traceLevel <= traceFlag ) {
        System.out.println( message );
        log.write( message );
        log.newLine();
        log.flush();
      }
    } catch( IOException e ) {
      // Was nun?
    }
  }

  static void openLog() throws IOException {
    log = new BufferedWriter( new FileWriter(logFile) );
    writeLog( 0, "Booting...");
  }

  static void closeLog() throws IOException {
    log.close();
  }
  
}
