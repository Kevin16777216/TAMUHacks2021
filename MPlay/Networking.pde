import java.io.*;  
import java.net.*; 
public class Networker{
  ServerSocket server;
  Socket socket;
  DataInputStream in;
  DataOutputStream out;
  boolean isServer;
  boolean isClosed=true;
  boolean connected = false;
  String publicIP = "localhost";
  public Networker(boolean isServer, String ip){
    this.isServer = isServer;
    this.publicIP = ip;
    try{
      if(isServer){
        server=new ServerSocket(65535);
        Runnable thread = new Runnable(){
          public void run(){
            block();
          }
        };
        Thread t = new Thread(thread);
        t.start();
      }else{
        socket=new Socket(ip,65535);   
        in=new DataInputStream(socket.getInputStream());
        out=new DataOutputStream(socket.getOutputStream());
      }
    }catch(Exception e){
      System.out.println(e);
      exit();
    }
  }
  public void block(){
    try{
      println("waiting");
      socket=server.accept();
      
      connected = true;
      in=new DataInputStream(socket.getInputStream());
      out=new DataOutputStream(socket.getOutputStream());
    }catch(Exception e){
    }
  }
  //Other Player's Sprite
  //Updates on solving a puzzle(add/removeObject)
  public boolean hasData(){
    try{
      return in.available()>0;
    }catch(Exception e){
      return false;
    }
  }
  public String getRawData(){
    if(hasData()){
      try{
        return in.readUTF();
      }catch(Exception e){
        return null;
      }
    }
    return null;
  }
 
}
