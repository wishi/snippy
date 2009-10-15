/*
 * Ein Schlafzyklus währt 720 und währt ewig!
 * Das dauert uns einfach zu lange, also schicken wir
 * einen jungen Prinzen vorbei.
 * Dieser setzt ein Flag und stoppt damit den Thread
 * nach 5 Sekunden.
 */

package thread_demo;

/**
 *
 * @author Marius Ciepluch
 */
public class Start_Stop extends Thread{

     	// umgehen der Compiler Optimirungen hier
        // halt Demo Code -> unrealistisch
        // Propellarhut-Zeug :)
    	protected volatile boolean gekuesst = false;

        // Schneewittchen will also schlafen
	public void run() {
		while (!gekuesst) {
			System.out.println("Schneewittchen schläft");
			try {
				sleep(720);
			} catch (InterruptedException ex) {
				// Es kam der junge Prinz...
                                // weil sie hatte nichts zu tun
			}
		}
		System.out.println("Schneewittchen ist wach!");
	}

	public void bussi() {
		gekuesst = true;
	}

	public static void main(String[] args) throws InterruptedException {
		
            Start_Stop zauberschlaf = new Start_Stop();
            
            zauberschlaf.start();
            Thread.sleep(1000*5); // Runtime trotzdem nur 5 Sekunden
            zauberschlaf.bussi();
	}
}