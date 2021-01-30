import java.io.*;  
import java.net.*; 
public class Networker{
  ServerSocket server;
  Socket socket;
  DataInputStream in;
  DataOutputStream out;
  boolean isServer;
  boolean isClosed=true;
  String publicIP = "localhost";
  public Networker(boolean isServer, String ip){
    this.isServer = isServer;
    try{
      if(isServer){
        server=new ServerSocket(65535);
        socket=server.accept();
        in=new DataInputStream(socket.getInputStream());
        out=new DataOutputStream(socket.getOutputStream());
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
