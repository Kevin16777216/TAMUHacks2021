public class LevelLoader extends Scene{
  GameLayer TileLayer;//Background
  GameLayer PlayerLayer;
  GameLayer UI;
  Player p;
  Polygon Sign;
  PVector origin;
  HashMap<Integer,GameObject> ObjSystem;
  public LevelLoader(String input){
    if(network!=null){
      if(network.isServer){
        network.writeData("LEVEL"+input);
      }else{
        input = network.getRawData();
      }
    }
    ObjSystem = new HashMap<Integer,GameObject>();
    TileLayer = new GameLayer(this);
    PlayerLayer = new GameLayer(this);
    UI = new GameLayer(this);
    renderMap.add(TileLayer);
    renderMap.add(PlayerLayer);
    renderMap.add(UI);
    Sign = new Polygon("Sign");
    UI.addDirect(Sign);
    Tile add;
    String[] lines = loadStrings(input);
    for (int i = 0 ; i < lines.length; i++) {
      add = parseLine(lines[i]);
      if(add != null){
        TileLayer.addDirect(add);
      }
    }
    create();
    HashSet<GameObject> tiles = getObj(tag.LINKTILE);
    if(tiles !=null){
      for(GameObject i:tiles){
          if(i instanceof LinkedTile){
           ((LinkedTile)i).setupLink();
          }else{
           ((LinkedTile)((Tile)i).subtiles[1]).setupLink();
          }
      }
    }
    //HashSet<GameObject> rtiles = getObj(tag.TILE);
    //if(rtiles !=null){
    //  for(GameObject i:rtiles){
    //      i.layer = TileLayer;
    //      if((Tile)i.)
    //  }
    //}
  }
  //fix
  public Tile parseLine(String line){
    if(line.length()<3)return null;
    line = line.substring(1,line.length()-1);
    String[]data = line.split(",");
    boolean link =data[0].equals("LINKED");
    int start = link?1:0;
    int x =int(data[start]);
    int y =int(data[start+1]);
    int id =int(data[start+2]);
    int uid =int(data[start+3]);
    int w =int(data[start+4]);
    int h =int(data[start+5]);
    String tg = data[start+6];
    boolean showColor=false;
    boolean reciever=false;
    boolean activated=false;
    int linked_1 = 0;
    int linked_2 = 0;
    if(link){
      linked_1 = int(data[start+10]);
      linked_2 = int(data[start+11]);
      if(data[start+9].equals("true")){
        showColor=true;
      }
      if(data[start+8].equals("true")){
        reciever=true;
      }
      if(data[start+7].equals("true")){
        activated=true;
      }
    }
    if(id == 2||id==10||id==11){
      //get extra
      LinkedTile newTile = new LinkedTile(x,y,id,uid, showColor,linked_1,linked_2);
      newTile.sc = this;
      newTile.w=w;
      newTile.h=h;
      newTile.tags.remove(tag.BLACK);
      newTile.tags.add(newTile.StrToTag(tg));
      tag c =newTile.getColorTag();
      switch(c){
        case RED:
          newTile.link = color(255,0,0);
          break;
        case GREEN:
          newTile.link = color(0,255,0);
          break;
        case BLUE:
          newTile.link = color(0,0,255);
          break;
        case YELLOW:
          newTile.link = color(255,255,0);
          break;
        default:
          newTile.link = color(0,0,0);
      }
      return newTile;
    }else{
      Tile subTile = null;
      if(!data[start+7].equals("{}")){
        String next = data[start+7]+",";
        for(int i = start+8;i<data.length-1;i++){
          next+=data[i]+",";
        }
        next+=data[data.length-1];
        subTile = parseLine(next);
        subTile.layer=TileLayer;
        
      }
      Tile newTile = new Tile(x,y,w,h,id,uid,tg);
      ObjSystem.put(uid,newTile);
      if(subTile!=null){
        if(subTile.id>11 && subTile.id<16){
          subTile.decoration = Sign;
        }
        newTile.setSubtile(subTile,1);
      }
      //newTile.subtiles[1]=subTile;
      if(id == 8){
        Player p = new Player(new Hitbox(1920/2-24,1080/2-24,48,48));
        TileLayer.dragLayer(new PVector(-x+(1920/2-24),-y+(1080/2-24)));
        TileLayer.setTranslation();
        PlayerLayer.addDirect(p);
        origin = new PVector(-x+(1920/2-24),-y+(1080/2-24));
        this.p = p;
      }else{
        
      }
      return newTile;
    }
  }
  public HashSet<GameObject> getSolid(){
    HashSet<GameObject> solids = getObj(tag.SOLID);
    return solids;
  }
  public Player getPlayer(){
    HashSet<GameObject> player = getObj(tag.PLAYER);
    if(player != null){
      for(GameObject i:player){
        return (Player)i;
      }
    }
    return null;
  }
  public GameObject getUID(int uid){
    for(GameObject i:objects){
      if(i instanceof Tile){
        if(((Tile)i).uid == uid)return i;
      }
    }
    return null;
  }
  @Override
  int update(){
    clear();
    int next = super.update();
    //TileLayer.dragLayer(PVector.mult(getPlayer().velocity,-1));
    //TileLayer.setTranslation();
    return super.update();
  }
  protected int handleStatus(int status){
    switch(status){
      //Exit Game->Main Menu
      case 3:
        return 1;
      default:
        return -1;
    }
  }
}
