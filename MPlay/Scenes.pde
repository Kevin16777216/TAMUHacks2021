//instruction pic
public class Screen extends GameObject {
  PImage image;
  public Screen(Scene s){
    super(s);
    
  }
  
  void chooseImage(String image_dir) {
    image = loadImage(image_dir);
  }
  
  void render(){
    image(image,0,0);
  }
}
//All Scenes excluding Level Editor and Main Game Scene()
public class Scene_Main_Menu extends Scene{
  //Screen image;
  GameLayer Background;
  GameLayer UI;
  GameLayer Curtain;
  public Scene_Main_Menu(){
    //image = new Screen(this);
    //image.chooseImage("Assests/instructions.jpg");
    Background = new GameLayer(this);
    UI = new GameLayer(this);
    Curtain = new GameLayer(this);
    renderMap.add(Background);
    renderMap.add(UI);
    renderMap.add(Curtain);
    SelectionButton Lobby = new SelectionButton(64,200,400,200);
    Lobby.setButtonSprite("Assets/main_menu.jpg");
    Lobby.setAction(5);
    SelectionButton Client = new SelectionButton(64,500,400,200);
    Client.setAction(6);
    Client.setButtonSprite("Assets/load_level.jpg");
    SelectionButton Instructions = new SelectionButton(64,800,400,200);
    Instructions.setButtonSprite("Assets/instructions.jpg");
    Instructions.setAction(3);
    SelectionButton EditLevel = new SelectionButton(660,1080-150,400,200);
    EditLevel.setButtonSprite("Assets/create_level.jpg");
    Lobby.toggleUse();
    Client.toggleUse();
    Instructions.toggleUse();
    EditLevel.setAction(4);
    EditLevel.toggleUse();
    //UI.addDirect(Lobby,Client,Instructions,EditLevel,new Curtain(10));
    UI.addDirect(Lobby,Client,Instructions,EditLevel);
    Curtain.addDirect(new menuCurtain());
  }
  @Override
  int update(){
    clear();
    background(201,241,255);
    return super.update();
  }
  protected int handleStatus(int status){
    
    switch(status){
      //Main Menu->Lobby Room
      case 1:
        return 1;
      //Main Menu->Client add Room
      case 2:
        return 2;
      //Main Menu->Instructions
      case 3:
        return 3;
      //Main Menu->Level Editor
      case 4:
        return 4;
      case 5:
        return 5;
      case 6:
        return 6;
      default:
        return -1;
    }
  }
}
//Instructions Screen
public class Instructions extends Scene{
  //Screen image;
  GameLayer Background;
  GameLayer UI;
  public Instructions(){
    //image = new Screen(this);
    //image.chooseImage("Assests/some.jgp");
    Background = new GameLayer(this);
    UI = new GameLayer(this);
    renderMap.add(Background);
    renderMap.add(UI);
    //test
    SelectionButton instruction = new SelectionButton(0,0,1920,1080);
    instruction.setButtonSprite("Assets/instruction_image.jpg");
    instruction.setAction(1);
    //SelectionButton Lobby = new SelectionButton(1920/2-700/2,200);
    //Lobby.setButtonSprite("Assets/back_to_menu.jpg",700,150);
    //Lobby.setAction(1);
    UI.addDirect(instruction);
   }
  @Override
  int update(){
   clear();
   return super.update();
  }
  
  protected int handleStatus(int status){
    
    switch(status){
      //Main Menu->Lobby Room
      case 1:
        return 1;
      case 2:
        //
      case 3:
        //
      case 4:
        //
      default:
        return -1;
    }
  }
}
//Waiting Screen
public class WaitingScreen extends Scene {
  Screen image;
  GameLayer Background;
  GameLayer UI;
  String ip;
  public WaitingScreen() {
    image = new Screen(this);
    //image.chooseImage("Assets/waiting.jpg");
    Background = new GameLayer(this);
    UI = new GameLayer(this);
    renderMap.add(Background);
    renderMap.add(UI);
    UI.addDirect(new WaitingAnimation());
    String[] ip = loadStrings("http://" + "icanhazip.com/");
    network = new Networker(true,ip[0]); 
  }
  int update(){
    if(network.connected == true){
      return 2;
    }
    return super.update();
  }
  void render(){
    super.render();
    fill(255);
    text(network.publicIP,0,0,700,100);
  }
   int handleStatus(int status){
    switch(status){
      case 1:
        //
      case 2:
        //
      case 3:
        //
      case 4:
        //
      default:
        return -1;
    }
  }
}
public class WaitingClientScreen extends Scene {
  Screen image;
  GameLayer Background;
  GameLayer UI;
  String ip;
  public WaitingClientScreen() {
    image = new Screen(this);
    //image.chooseImage("Assets/waiting.jpg");
    Background = new GameLayer(this);
    UI = new GameLayer(this);
    renderMap.add(Background);
    renderMap.add(UI);
    UI.addDirect(new WaitingAnimation());
    network = new Networker(false,"71.183.227.220"); 
  }
  int update(){
    if(network.connected == true){
      return 2;
    }
    return super.update();
  }
  void render(){
    super.render();
    fill(255);
    text("Connecting...",0,0,700,100);
    ///super.render();
  }
   int handleStatus(int status){
    switch(status){
      case 1:
        //
      case 2:
        //
      case 3:
        //
      case 4:
        //
      default:
        return -1;
    }
  }
}
