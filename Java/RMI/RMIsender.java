import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

/**
 * Created by IntelliJ IDEA.
 * User: wishi
 * Date: 17.01.2010
 * Time: 15:04:37
 * To change this template use File | Settings | File Templates.
 */
/*
1.   host 1: java RmiServer
2.   host 2: (at another host) java RmiClient <servers address> 1099
*/

public class RMIsender {
    static public void main(String args[]) {
        RMIReceiver rmiServer;
        Registry registry;
        String serverAddress = args[0];  // localhost for demo purposes
        String serverPort = args[1]; // use 8080 for default
        String text = "foo";        // preinit due warning

        try {

            while (!text.equals("end")) {
                text = System.console().readLine();
                System.out.println("Sending " + text + " to " + serverAddress + ":" + serverPort);

                // get the “registry”
                registry = LocateRegistry.getRegistry(serverAddress, (new Integer(serverPort)).intValue());

                // look up the remote object
                rmiServer = (RMIReceiver) (registry.lookup("rmiServer"));

                // call the remote method
                rmiServer.receive(text);
            }



        }
        catch (RemoteException e) {
            e.printStackTrace();
        }
        catch (NotBoundException e) {
            e.printStackTrace();
        }
    }
}


