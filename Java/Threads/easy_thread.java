/*
 * Gaaanz easy: 
 * * 2 Threads werden erzeugt
 * * Ihre Arbeit wird abwechselnd getan
 * * Sie haben unterschiedlich viel zu tun, daher endet Y später
 * 
 */

package thread_demo;

/**
 *
 * @author Marius
 */
public class easy_thread extends Thread{

	String mesg;
	int count;

	// run -> Arbeit rein
	public void run() {
		while (count-- > 0) {
			println(mesg);
			try {
				Thread.sleep(100);	// 100 msec
			} catch (InterruptedException e) {
				return;
			}
		}
		println(mesg + " komplett fertig.");
	}

	void println(String s) {
		System.out.println(s);
	}

	/**
	 * Nen easy_thread Objekt bauen -> Konstruktor
	 * @param m Message to display
	 * @param n How many times to display it
	 */
	public easy_thread(String m, int n) {
		count = n;
		mesg  = m;
		setName(m + " runner Thread");
	}

	/**
	 * So... ab gehts:
	 */
	public static void main(String[] argv) {
		// achtung: new easy_thread("Hello from X", 10).run();
		//          new easy_thread("Hello from Y", 15).run();
		// IST NICHT MULTITHREADED!!!1!!1! :)

		new easy_thread("Hallo Welt aus X", 10).start();
		new easy_thread("Hallo Welt aus Y", 15).start();
	}
}



