import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;

/**
 * Created by IntelliJ IDEA.
 * User: wishi
 * Date: 10.01.2010
 * Time: 11:38:25
 * To change this template use File | Settings | File Templates.
 */
public class UDP_rcv {

    public final static int udp_port = 8205;  // Vorgabe

    public static void main(String[] argv) throws IOException, ClassNotFoundException {


        DatagramSocket Socket = null;
        DatagramPacket Packet = null;
        byte[] Buffer = null;


        try {

            /*
            byte[] data=new byte[1000];
            ObjectInputStream in = new ObjectInputStream(new ByteArrayInputStream(data));
            */

            Socket = new DatagramSocket(udp_port); // listen
            Buffer = new byte[2048];
            Packet = new DatagramPacket(Buffer, Buffer.length);

            /*
            String message = in.readObject().toString();
            */
            Socket.receive(Packet);
            System.out.println(new String(Packet.getData(), 5, Packet.getLength()));
            // getRemoteSocketAddress() geht wahrscheinlich nur mit 2. Rechner
            System.out.println("Port: " + udp_port + " Remote-Host: " + Socket.getRemoteSocketAddress());


        } catch (SocketException e) {
            System.out.println("Could not open the socket: \n" + e.getMessage());
            System.exit(1);
        }

    }
}