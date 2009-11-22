package tcp_server;
/**
 * @author Marius Ciepluch
 * Verteilte Systeme Praktikum
 * Single-threaded client
 * receives an ACK 
 */

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ConnectException;
import java.net.NoRouteToHostException;
import java.net.Socket;
import java.net.UnknownHostException;


public class TCPSender {

    /**
     * <EntryPoint>
     * @param argv
     * @throws ClassNotFoundException 
     * @throws IOException 
     */
    public static void main(String[] argv) throws ClassNotFoundException, IOException {
             
        
        String server_name = argv.length == 1 ? argv[0] : "localhost";
        final int tcp_port = 8205;                    // Vorgaben
        String ack="Ok";                        // -> ohne SessionID etc.
        
        Socket echoSocket = null;
        ObjectInputStream in = null;
        ObjectOutputStream out = null;
                
        try {
            echoSocket = new Socket(server_name, tcp_port);
            System.out.println(" *** Connected to " + server_name  + " ***");
            System.out.println("Press Enter to send your message.");
            
            out = new ObjectOutputStream(echoSocket.getOutputStream());
            in = new ObjectInputStream(echoSocket.getInputStream());
            
            echoSocket.setSoTimeout(100); // 1 sek - DEBUG
            
            out.flush();
            
            String message="pre"; //  = System.console().readLine();
            
            while(!message.equals("quit")) {
          
                // <EntryPoint>
                System.out.print("> ");
                message = System.console().readLine();
                out.writeObject(message);
                System.out.println("Sent: " + message);  
                out.flush();
                               
                String response = in.readObject().toString();
                if (response.equals(ack)) 
                    System.out.println("Message ACK from " + server_name + "\n\n");
                
            } // -- end of while
            
            // out.writeObject(ack);
                        
            out.close();
            in.close();
 
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
        } finally {
            System.out.println("Bye");
            echoSocket.close();
        }
        
  
    } // -- end of main 

}
// EOF