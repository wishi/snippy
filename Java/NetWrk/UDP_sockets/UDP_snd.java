import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.*;
import java.rmi.ConnectException;

/**
 * Created by IntelliJ IDEA.
 * User: wishi
 * Date: 10.01.2010
 * Time: 10:42:43
 */
public class UDP_snd {

    public final static int udp_port = 8205;  // Vorgabe

    public static void main(String[] args) throws ClassNotFoundException, IOException {

        try {
            String server_name = args.length == 1 ? args[0] : "localhost";

            DatagramSocket echoSocket = null;        // == UDP Socket
            echoSocket = new DatagramSocket();

            String message = "pre"; // init-Wert
            while (!message.equals("quit")) {

                System.out.println(" *** Contact with " + server_name + " ***");
                System.out.println("Press Enter to send your message.");

                // <EntryPoint>
                System.out.print("> ");
                message = System.console().readLine();

                ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                ObjectOutputStream out = new ObjectOutputStream(buffer);
                out.writeObject(message);

                out.close();
                buffer.close();

                DatagramPacket packet = new DatagramPacket(buffer.toByteArray(),
                        buffer.size(),
                        InetAddress.getByName(server_name),
                        udp_port);
                echoSocket.send(packet);

            }


        } catch (UnknownHostException e) {
            System.err.println("Unknown host");
            return;
        } catch (NoRouteToHostException e) {
            System.err.println("Unreachable");
            return;
        } catch (ConnectException e) {
            System.err.println("connect refused");
            return;
        } catch (java.io.IOException e) {
            System.err.println(e.getMessage());
            return;
        } finally {
            System.out.println("Bye");
            // echoSocket.close();
        }


    } // -- end of main

}
// EOF