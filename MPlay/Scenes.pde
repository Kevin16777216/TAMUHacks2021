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
  public Scene_Main_Menu(){
    //image = new Screen(this);
    //image.chooseImage("Assests/instructions.jpg");
    Background = new GameLayer(this);
    UI = new GameLayer(this);
    renderMap.add(Background);
    renderMap.add(UI);
    SelectionButton Lobby = new SelectionButton(1920/2-700/2,200);
    Lobby.setButtonSprite("Assets/instructions_resized.jpg",1920/2-700/2,200);
    Lobby.setAction(1);
    SelectionButton Client = new SelectionButton(1920/2-700/2,500);
    Client.setAction(2);
    //SelectionButton Instructions = new SelectionButton(1920/2-700/2,800);
    SelectionButton Instructions = new SelectionButton(1920/2,100);
    Instructions.setAction(3);
    SelectionButton EditLevel = new SelectionButton(1920-400,1080-150);
    Lobby.toggleUse();
    Client.toggleUse();
    Instructions.toggleUse();
    EditLevel.setAction(4);
    EditLevel.toggleUse();
    //UI.addDirect(Lobby,Client,Instructions,EditLevel,new Curtain(10));
    UI.addDirect(Lobby,Client,Instructions,EditLevel,new menuCurtain());
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
      //Main Menu->Client add Room
      case 2:
        return 2;
      //Main Menu->Instructions
      case 3:
        return 3;
      //Main Menu->Level Editor
      case 4:
        return 4;
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
    SelectionButton Lobby = new SelectionButton(1920/2-700/2,200);
    Lobby.setAction(1);
    UI.addDirect(Lobby);
    
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
  public WaitingScreen() {
    image = new Screen(this);
    //image.chooseImage("Assets/waiting.jpg");
    Background = new GameLayer(this);
    UI = new GameLayer(this);
    renderMap.add(Background);
    renderMap.add(UI);
    UI.addDirect(new WaitingAnimation());
    
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
