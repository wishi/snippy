package thread_demo;

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
                System.out.println(input_number*input_number);
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
            System.out.println("Bitte geben Sie eine Zahl ein und bestärigen sie mit Enter!");
            System.out.print("[ x^2; x= ] ");

            BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
            puffer = Long.valueOf(in.readLine()).longValue();

            while(!end) {
                if(puffer!=0){
                    easy_thread hochzwei = new easy_thread(puffer);
                    hochzwei.start();
                    puffer = Long.valueOf(in.readLine()).longValue();
                }

                if(puffer==0)
                    end=true;
            } //  -- end of while

    } // -- end of main

 } // -- end of CLASS
 // EOF