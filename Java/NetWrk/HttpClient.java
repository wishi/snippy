import java.io.*;
import java.net.*;


public class HttpClient {

    /**
     * synchron, http
     * 
     * @param argv - defaults to localhost, server-name 
     * @throws ClassNotFoundException 
     */
    public static void main(final String[] argv) throws IOException, MalformedURLException {

       String url_name = argv.length == 1 ? argv[0] : "http://www.crazylazy.info/index.html";
                     
        try {
            // gemaess SUNs Tutorial:
            // http://java.sun.com/docs/books/tutorial/networking/urls/readingWriting.html
                        
            URL url = new URL(url_name);
            URLConnection kaze = url.openConnection();
            kaze.setReadTimeout(10);       // gilt nur, wenn server da, aber nicht antwortet
            
            BufferedReader in = new BufferedReader(new InputStreamReader(kaze.getInputStream()));
            String inputLine;

            // Output 
            while ((inputLine = in.readLine()) != null) 
                System.out.println(inputLine);
            
            in.close();
 
        } catch (UnknownHostException e) {
            System.err.println(url_name + " Unknown host");
            return;
        } catch (NoRouteToHostException e) {
            System.err.println(url_name + " Unreachable" );
            return;
        } catch (ConnectException e) {
            System.err.println(url_name + " connect refused");
            return;
        } catch (MalformedURLException badurl){
            System.err.println("url_name" + ' ' + badurl.getMessage());
            return;
        } finally {        
            System.out.println("EOF");
        }
       
    } // -- end of main
        

} 
// EOF