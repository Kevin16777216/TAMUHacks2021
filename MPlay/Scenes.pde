import processing.serial.*;
//All Scenes excluding Level Editor and Main Game Scene()
public class Scene_Main_Menu extends Scene{
  GameLayer Background;
  GameLayer UI;
  public Scene_Main_Menu(){
    //drops curtain
    //menuCurtain test = new menuCurtain(false);
    //  test.setBackground();
    //  while(test.check==false){
    //  test.update();
    //  test.render();
      
    //}
    //finishes dropping curtain
    Background = new GameLayer(this);
    UI = new GameLayer(this);
    renderMap.add(Background);
    renderMap.add(UI);
    SelectionButton Lobby = new SelectionButton(1920/2-700/2,200);
    Lobby.setAction(1);
    SelectionButton Client = new SelectionButton(1920/2-700/2,500);
    Client.setAction(2);
    SelectionButton Instructions = new SelectionButton(1920/2-700/2,800);
    Instructions.setAction(3);
    SelectionButton EditLevel = new SelectionButton(1920-400,1080-150);
    Lobby.toggleUse();
    Client.toggleUse();
    Instructions.toggleUse();
    EditLevel.setAction(4);
    EditLevel.toggleUse();
    //UI.addDirect(Lobby,Client,Instructions,EditLevel, new Curtain(1));
    UI.addDirect(Lobby,Client,Instructions,EditLevel, new menuCurtain());
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
