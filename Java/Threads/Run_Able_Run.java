package thread_demo;


/**
 * Threaded demo app using Runnable. Forest... aeh Able soll laufen
 * @author	Marius
 * @version     1
 */
public class Run_Able_Run implements Runnable {
	String mesg;
	Thread t;
	int count;

	/**
	 * Main program, test driver for Run_Able_Run class.
	 */
	public static void main(String[] argv) {
		new Run_Able_Run("Hallo from X", 10);
		new Run_Able_Run("Hallo from Y", 15);
	}

	/**
	 * Construct a ThreadsDemo2 object
	 * @param m Message to display
	 * @param n How many times to display it
	 */
	public Run_Able_Run(String m, int n) {
		count = n;
		mesg  = m;
		t = new Thread(this);
		t.setName(m + " runner Thread");
		t.start();
	}

	/** Run does the work. We override the run() method in Runnable. */
	public void run() {
		while (count-- > 0) {
			println(mesg);
			try {
				Thread.sleep(100);	// 100 msec
			} catch (InterruptedException e) {
				return;
			}
		}
		println(mesg + " thread all done.");
	}

	void println(String s) {
		System.out.println(s);
	}
}
