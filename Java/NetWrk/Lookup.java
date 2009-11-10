
import java.net.*;

public class Lookup
{
    public static void main(final String[] args)
    {
        if (args.length != 1) {
            System.err.println("Usage: java Lookup IPAddress|Hostname");
            System.exit(1);
        }
        try {
            //Get requested address
            InetAddress addr[] = InetAddress.getAllByName(args[0]);
            System.out.println(addr[0].getHostName());
      

            int i=0;
            while(addr.length>i){
                System.out.println(addr[i].getHostAddress());
                i++;
            } // -- end of while
        
        } catch (UnknownHostException e) {
            System.err.println(e.toString());
            System.exit(1);
        } // -- end of try-catch
  
    } // -- end of main()

} // end of Lookup
// EOD


