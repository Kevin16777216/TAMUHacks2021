public class LevelLoader extends Scene{
  GameLayer TileLayer;//Background
  GameLayer PlayerLayer;
  GameLayer UI;
  public LevelLoader(String input){
    TileLayer = new GameLayer(this);
    PlayerLayer = new GameLayer(this);
    UI = new GameLayer(this);
    renderMap.add(TileLayer);
    renderMap.add(PlayerLayer);
    renderMap.add(UI);
    String[] lines = loadStrings(input);
    for (int i = 0 ; i < lines.length; i++) {
      parseLine(lines[i]);
    }
  }
  //fix
  public void parseLine(String line){
    if(line.length()<3)return;
    line.substring(1,line.length()-1);
    String[]data = line.split(",");
    println(data[0]);
    boolean link =data[0].equals("LINKED");
    int start = link?1:0;
    int x =int(data[start]);
    int y =int(data[start+1]);
    int id =int(data[start+2]);
    int uid =int(data[start+3]);
    int w =int(data[start+4]);
    int h =int(data[start+5]);
    String tag = data[start+6];
    if(id == 2||id==10||id==11){
      //get extra
      //LinkedTile newTile = new LinkedTile();
      /////
      //TileLayer.addDirect(newTile);
    }else{
      print(tag);
      Tile newTile = new Tile(x,y,w,h,id,uid,tag);
      if(id == 8){
        //Make a new Player Object
      }else{
        
      }
      TileLayer.addDirect(newTile);
    }
  }
  @Override
  int update(){
    clear();
    return super.update();
  }
  protected int handleStatus(int status){
    switch(status){
      //Exit Game->Main Menu
      case 5:
        return 1;
      default:
        return -1;
    }
  }
}
