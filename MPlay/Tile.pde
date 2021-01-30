public class Tile extends GameObject implements Physical{
  protected int x,y,id,uid,w=64,h=64;
  final color[] tileColors = {color(179, 130, 18),color(0,0,0),color(227, 90, 75),color(101, 196, 240),color(78, 194, 112)};
  Tile[] subtiles;
  Hitbox box;
  String loadMode = "EDITOR";
  PImage data;
  int transparency = 255;
  public Tile(int x, int y, int id,int uid) {
    this.x = x;
    this.y = y;
    this.id = id;
    this.uid = uid;
    box = new Hitbox(new PVector(x,y),new PVector(w,h));
    tags.add(tag.TILE);
    subtiles = new Tile[5];
    setupTag();
  }
  public void setSubtile(Tile t,int layer){
    subtiles[layer] = t;
  }
  public Tile getSubtile(int layer){
    return subtiles[layer];
  }
  private void setupTag(){
    switch(id){
      //Ground
      case 0:  
        break;
      //Wall
      case 1:
        tags.add(tag.SOLID);
        break;
      //Teleporter
      case 2:
        tags.add(tag.TELEPORT);
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      default:
        break;
    }
  }
  public int getID() {return id;}
  public void setID(int id){
    this.id = id;
    
  }
  public Hitbox getHitbox(){return box;}
  public void setX(int x){this.x = x;}
  public void setY(int y){this.y = y;}
  public int getX(){return x;}
  public int getY(){return y;}
  public void setW(int w){this.w = w;}
  public void setH(int h){this.h = h;}
  void render() {
    //Choosing load size based on if the game is in the editor or not.
    if(loadMode.equals("EDITOR")){
      fill(tileColors[id],transparency);
      strokeWeight(3);
      rect(x,y,w,h);
      for(Tile i:subtiles){
        if(i != null){
          i.render();
        }
      }
    }else if(loadMode.equals("GAME")){
    
    }
  }
  int update() {return 0;}
}

public class LinkedTile extends Tile{
  final color[] tileColors = {color(255, 0, 0),color(0,255,0),color(255, 255, 0),color(225, 0, 255),color(0,0,0)};
  color colorType;
  Tile linkedTile_1;
  Tile linkedTile_2;
  //Does this tile react to other tiles, or send a signal to a tile?
  boolean reciever = false;
  boolean activated = false;
  //showColor:should this tile show it's color when running the game?
  boolean showColor=true;
  //showingColor:should the tile show it's color?(Changing this variable will change the color mid-game)
  boolean showingColor = true;
  public LinkedTile(int x, int y, int id,int uid,color colorType,boolean showColor){
    super(x,y,id,uid);
    this.colorType = colorType;
    this.showColor = showColor;
  }
  public void findLink(){
    
  }
  public void sendSignal(){
  }
}
