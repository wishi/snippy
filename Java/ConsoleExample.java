/*
	* no need for BufferedStreamReader since Java 6 introduced Console() class
	* -> tryParse finden - nicht static

*/


public class ConsoleExample{


    public static void main(final String[] argv){

				System.out.println("foo");    
        int foo = Integer.parseInt(System.console().readLine());
        Integer.
        System.out.println(foo);
        
    } // -- end of main
    


}
