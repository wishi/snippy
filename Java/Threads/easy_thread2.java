import java.io.*;

/**
 *
 * @author Marius
 */
public class easy_thread extends Thread{

    private long input_number;

    @Override
    public void run() {

           try{
                System.out.printf("x^2 =  %d\n", input_number*input_number);
                // -- end of if-else
            } catch (Exception e) {
                return;
            }
        } // -- end of run


    /**
     * Konstruktor fuer die Threads
     * @param zahl - soll quadriert werden
     */
    public easy_thread(long zahl) {

            this.input_number=zahl;
            setName(zahl + " runner Thread");
    }
    
    public static void main(final String[] argv) throws IOException{

            boolean end=false;
            long puffer;
            System.out.println("Bitte geben Sie eine Zahl ein und bestätigen sie mit Enter! Zum Beenden 0.");
            //System.out.println("[ x^2; x= ] x: ");
            
            BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
            puffer = Long.valueOf(in.readLine()).longValue();
        
            while(!end) {
                 try {
                    if(puffer!=0){
                        easy_thread hochzwei = new easy_thread(puffer);
                        hochzwei.start();
                        puffer = Long.valueOf(in.readLine()).longValue();
                    }
                
                    if(puffer==0) {
                        System.out.println("BYE BYE!");
                        end=true;
                    }
                } catch (Exception e) {
                    System.out.print("[*] Fehler: wiederholen Sie die Eingabe!\n");
                    puffer = Long.valueOf(in.readLine()).longValue();
                } // -- end of try/catch
            } //  -- end of while
    } // -- end of main
} // -- end of CLASS
 // EOF