package tcp_server;
/**
 * 
 */

import java.io.*;
import java.net.ConnectException;
import java.net.NoRouteToHostException;
import java.net.Socket;
import java.net.UnknownHostException;




/**
 * @author Marius Ciepluch
 * Verteilte Systeme Praktikum
 *
 */
public class TCPSender {

    /**
     * @param argv
     * @throws ClassNotFoundException 
     * @throws IOException 
     */
    public static void main(String[] argv) throws ClassNotFoundException, IOException {
             
        
        String server_name = argv.length == 1 ? argv[0] : "localhost";
        int tcp_port = 8205;                    // gem. Aufgabe 
        String ack="Ok";
        
        Socket echoSocket = null;
        ObjectInputStream in = null;
        ObjectOutputStream out = null;
                
        try {
            echoSocket = new Socket(server_name, tcp_port);
            System.out.println(" *** Connected to " + server_name  + " ***");
            System.out.println("Press Enter to send your message.");
            
            out = new ObjectOutputStream(echoSocket.getOutputStream());
            in = new ObjectInputStream(echoSocket.getInputStream());
            
            out.flush();
            
            String message = System.console().readLine();
            
            while(!message.equals("quit")) {
                                                
                out.writeObject(message);
                System.out.println("Sending: " + message);      
                message = System.console().readLine();
                out.flush();
                               
            }
            
                           
 
        } catch (UnknownHostException e) {
            System.err.println(server_name + " Unknown host");
            return;
        } catch (NoRouteToHostException e) {
            System.err.println(server_name + " Unreachable" );
            return;
        } catch (ConnectException e) {
            System.err.println(server_name + " connect refused");
            return;
        } catch (java.io.IOException e) {
            System.err.println(server_name + ' ' + e.getMessage());
            return;
        } 
        
            out.close();
           
        
        
    } // -- end of main 

}




