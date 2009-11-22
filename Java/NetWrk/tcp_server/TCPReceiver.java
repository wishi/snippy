/**
 * @author Marius Ciepluch
 * Praktikum Verteilte Systeme
 * TCP Echo server mit sequentieller Allokation 
 * betaetigt dem Client mit dem ack String 
 *
 */

package tcp_server;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class TCPReceiver {

    public static final int PORT = 8205;
    public static boolean RUN=true;
    
    /**
     * @param args
     */
    public static void main(final String[] argv) {
  
        new TCPReceiver().runServer();
    } // -- end of main

            // starts server
            public void runServer() {
                
                ServerSocket socket;
                Socket clientSocket;

                try {
                    socket = new ServerSocket(PORT);
                
                    System.out.println(" TCPReceiver is ready for connections.");

                    // soll immer auf verbindungen warten und annehmen
                    while(RUN){
                        clientSocket = socket.accept();
                        new Handler(clientSocket).start();
                    }
                                    
                } catch(IOException exception) {
                    // bei Problemen - Zwangs-Exception
                    System.err.println("Error " + exception);
                    System.exit(1);
                } 
            
            } // -- end of runServer()

            
            
            /** Dies ist die Thread Unterklasse zum Handeln der TCP connections */
            class Handler extends Thread {
                
                Socket socket;

                Handler(Socket s) {
                    socket = s;
                }

                @Override
                public void run() {
                    
                    // hier ähnlich wie der EchoClient aus dem letzten Praktikum
                    // nur eben nebenlaeufig
                    
                    // Ausgabe zum Debug... socket hat eine Methode dafuer
                    System.out.println("Socket starting: " + socket);
                    
                    ObjectInputStream in = null;
                    ObjectOutputStream os = null;
                    
                    try {
                                                
                        in = new ObjectInputStream(socket.getInputStream());
                        os = new ObjectOutputStream(socket.getOutputStream());
                        
                        String line="pre"; //  = in.readObject().toString();
                        String ack="Ok";
                        
                        while ((line = in.readObject().toString()) != "quit") {
                            // Internetadresse bzw. dem Rechnernamen und der Portnummer des Senders 
                            // stehen im socket String hier dann
                            System.out.println("Starte: " + socket + " in " + Thread.currentThread().toString());
                            System.out.println("Nachricht: " + line);
                            System.out.println("Bestätige mit " + ack);
                            os.writeObject(ack);
                            os.flush();
                        }
                        in.close();
                        os.close();
                        socket.close();
                        TCPReceiver.RUN=false;
                                            
                    } catch (IOException e) {
                        System.out.println("IO Error on socket " + e);
                        return;
                    } catch (ClassNotFoundException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    } finally {
                        System.out.println("Bye");
                
                    }
                    
                    System.out.println("Socket closed: " + socket);
                   
                }
            }
      }


