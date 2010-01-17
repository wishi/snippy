// beware: no sec policy implemented
// default stublayer will be in sha1 "64" bit with low entropy
// -> stub -> call for methods -> data
// do not copy

import java.net.InetAddress;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

/**
 * Created by IntelliJ IDEA.
 * User: wishi
 * Date: 17.01.2010
 * Time: 14:49:45
 * To change this template use File | Settings | File Templates.
 */
// = server mit geschaeftslogistischen prozessen
    /*

1. javac RmiServer.java
2. rmic RmiServer
3. javac RmiClient.java

     */

public class RMIReceiverImpl
        extends java.rmi.server.UnicastRemoteObject
        implements RMIReceiver {

    int thisPort;
    String thisAddress;
    Registry registry;    // rmi registry to lookup remote objects.

    public RMIReceiverImpl() throws RemoteException {

        try {
            // get local address
            thisAddress = (InetAddress.getLocalHost()).toString();
        }
        catch (Exception e) {
            throw new RemoteException("can't get inet address.");
        }

        thisPort = 8080;  // change if local policy disallows

        System.out.println("this address=" + thisAddress + ",port=" + thisPort);

        try {
            // create the registry and bind the name and object.
            registry = LocateRegistry.createRegistry(thisPort);
            registry.rebind("rmiServer", this);
        }
        catch (RemoteException e) {
            throw e;
        }
    }


    public void receive(String message) throws RemoteException {

        System.out.println(message);
    }


    static public void main(String args[]) {

        try {
            RMIReceiverImpl s = new RMIReceiverImpl();
        }
        catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

}
// EOF