/**
 * @author Marius Ciepluch
 * Praktikum Verteilte Systeme
 * TCP Echo server mit sequentieller Allokation 
 *
 */

package tcp_server;

import java.net.*;
import java.io.*;

public class TCPReceiver {

    public static final int PORT = 8205;
    
    /**
     * @param args
     */
    public static void main(String[] argv) {
  
        new TCPReceiver().runServer();
            
    }

            public void runServer() {
                
                ServerSocket socket;
                Socket clientSocket;

                try {
                    socket = new ServerSocket(PORT);
                
                    System.out.println(" TCPReceiver is ready for connections.");

                    // soll immer auf verbindungen warten und annehmen
                    while(true){
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
                    
                    // hier aehnlich wie der EchoClient aus dem letzten Praktikum
                    // nur eben in Threads
                    
                    // Ausgabe zum Debug... socket hat eine Methode dafuer
                    System.out.println("Socket starting: " + socket);
                    
                    ObjectInputStream in = null;
                    ObjectOutputStream os = null;
                    
                    try {
                                                
                        in = new ObjectInputStream(socket.getInputStream());
                        os = new ObjectOutputStream(socket.getOutputStream());
                        
                        String line="pre"; //  = in.readObject().toString();
                        String ack="Ok";
                        
                        while ((line = in.readObject().toString()) != null) {
                            // Internetadresse bzw. dem Rechnernamen und der Portnummer des Senders
                            if (line.equals(ack)) {
                                System.out.println("Bestaetige mit: " + ack);
                                os.writeObject(ack);
                                os.flush();
                            }
                            
                            System.out.println("Starte: " + socket);
                            System.out.println("Nachricht: " + line);
                            // System.out.println("Bestaetige mit " + ack);
                            os.flush();
                        }
            
                        socket.close();
                    
                    } catch (IOException e) {
                        System.out.println("IO Error on socket " + e);
                        return;
                    } catch (ClassNotFoundException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    
                    System.out.println("Socket closed: " + socket);
                }
            }
      }


