package Scheduler;

/* Ein schmutziges Mehrzweckobjekt. Die Attribute stehen mehr oder weniger
 * zur freien Verfügung. Benutzung erfolgt auf eigene Gefahr.
 * In einer späteren Projektphase, wenn etwas klarer ist, wo überall und
 * für welche Zwecke Events eingesetzt werden, kann hier etwas mehr Ordnung
 * hineingebracht werden.
 */

import Hardware.SysConsole;

public class Event {
    private int type; // Typ des Events
    private int id; // Zusatzinfo, z.B. PID
    private int address; // Hauptspeicheradresse für DMA
    private String content; // Rückgabewert/Ergebnis des Events
    private SysConsole console;
    
    /*EventType definitionen */
    public static final int undefiniert = -1;
    public static final int read = 0;
    public static final int write = 1;
    public static final int wait = 2;

    public Event( int type, int id ) {
        this( type, id, -1 );
        content = null;
    }
    
    public Event( int type, int id, int address ) {
        this.type = type;
        this.id = id;
        this.address = address;
        content = null;
    }
    
    public String toString() {
        return "[type:" + type + ", id:" + id + ", address:" + address
               + ", content:" + content + "]";
    }
    
    public int getType() {
        return type;
    }
    public void setType( int type ) {
        this.type = type;
    }

    public int getID() {
        return id;
    }
    public void setID( int id ) {
        this.id = id;
    }

    public int getAddress() {
        return address;
    }
    public void setAddress( int address ) {
        this.address = address;
    }

    public String getContent() {
        return content;
    }
    public void setContent( String content ) {
        this.content = content;
    }
    
    public SysConsole getConsole() {
        return console;
    }
    public void setConsole( SysConsole console ) {
        this.console = console;
    }
}
