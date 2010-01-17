import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * Created by IntelliJ IDEA.
 * User: wishi
 * Date: 17.01.2010
 * Time: 14:45:58
 * To change this template use File | Settings | File Templates.
 */
public interface RMIReceiver extends Remote {

    public void receive(String message) throws RemoteException;

}
