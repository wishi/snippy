package Hardware;

import javax.swing.*;
import java.awt.event.*;
import java.awt.*;
import java.util.*;
import java.io.*;

public class SysConsole extends JFrame {
//  private JButton clearButton = new JButton("Clear");
  private JTextArea textArea;
  private int currentPos = 0;
  private int refCount;
  private int id;
  
  public SysConsole( final IO io, int id, String title ) {
    textArea = new JTextArea(20, 40);
    refCount = 1;
    this.id = id;
    setTitle( title );
//    textArea.setFont( new Font("Courier", Font.PLAIN, 14) );

/*    clearButton.addActionListener( new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        textArea.setText("");
      }
    });
 */
    textArea.addKeyListener( new KeyListener() {
      @Override
      public void keyPressed( KeyEvent e ) {
        if( e.getKeyChar() == '\n' ) {
          io.receiveReadContent( getId(), read() );
        }
      }
      @Override
      public void keyTyped( KeyEvent e ) {}
      @Override
      public void keyReleased( KeyEvent e ) {}
    });
    Container cp = getContentPane();
    cp.setLayout( new FlowLayout() );
    cp.add( new JScrollPane(textArea) );
//    cp.add( clearButton );
  }
  
  public void write( String message ) {
    textArea.append( message );
    currentPos = textArea.getDocument().getLength();
    textArea.setCaretPosition( currentPos );
  }
  
  private String read() {
    String text = textArea.getText().substring(currentPos);
    currentPos += text.length()+1;
    return text;
  }
  
  public int getId() {
    return id;
  }
  
  public void incRefCount() {
    refCount++;
  }
  
  public void decRefcount() {
    if( refCount > 0 ) {
      refCount--;
    }
  }
  
  public boolean zeroRefCount() {
    return refCount == 0;
  }
}
