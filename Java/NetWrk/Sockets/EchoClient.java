package pingpong;

import java.io.*;
import java.net.ConnectException;
import java.net.NoRouteToHostException;
import java.net.Socket;
import java.net.UnknownHostException;


public class EchoClient {

    /**
     * @param Servername as String from argv
     * @throws ClassNotFoundException 
     */
    public static void main(final String[] argv) throws IOException, ClassNotFoundException {

        String server_name = argv.length == 1 ? argv[0] : "localhost";
        int tcp_port = 7777; 
        
        Socket echoSocket = null;
        ObjectOutputStream out = null;
        ObjectInputStream in = null;
        
        try {
            echoSocket = new Socket(server_name, tcp_port);
            System.out.println(" *** Connected to " + server_name  + " ***");
            
            out = new ObjectOutputStream(echoSocket.getOutputStream());
            out.flush();
            
            String ping="hel0";                        // send-Info
            System.out.println("Sending " + ping);
            out.writeObject(ping);
            
            
            in = new ObjectInputStream(echoSocket.getInputStream());
            
            String pong;
            pong = in.readObject().toString();
            
            if(ping.equals(pong))
                System.out.println("Success");
                           

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
            out.close();
            in.close();
        }
        
             
       
        
    } 

}
