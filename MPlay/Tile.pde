public class Tile extends GameObject implements Physical{
  protected int x,y,id,uid,w=64,h=64;
  Tile[] subtiles;
  Hitbox box;
  String loadMode = "EDITOR";
  PImage data;
  int transparency = 255;
  color link = color(0,0,0);
  public Tile(int x, int y, int id,int uid) {
    this.x = x;
    this.y = y;
    this.id = id;
    this.uid = uid;
    tags.add(tag.BLACK);
    box = new Hitbox(new PVector(x,y),new PVector(w,h));
    tags.add(tag.TILE);
    subtiles = new Tile[5];
    setupTag();
  }
  public Tile(int x, int y,int w,int h,int id,int uid,String tg){
    this(x,y,id,uid);
    this.w=w;
    this.h=h;
    tags.remove(tag.BLACK);
    tags.add(StrToTag(tg));
  }
  public tag StrToTag(String s){
    switch(s){
      case "RED":
        return tag.RED;
      case "GREEN":
        return tag.GREEN;
      case "BLUE":
        return tag.BLUE;
      case "YELLOW":
        return tag.YELLOW;
      default:
        return tag.BLACK; 
    }
  }
  public tag getColorTag(){
    if(tags.contains(tag.RED))return tag.RED;
    if(tags.contains(tag.GREEN))return tag.GREEN;
    if(tags.contains(tag.BLUE))return tag.BLUE;
    if(tags.contains(tag.YELLOW))return tag.YELLOW;
    return tag.BLACK;
  }
  public tag getBaseTag(){
    if(tags.contains(tag.TELEPORT))return tag.TELEPORT;
    if(tags.contains(tag.PLATE))return tag.PLATE;
    if(tags.contains(tag.DOOR))return tag.DOOR;
    if(tags.contains(tag.SPAWN))return tag.SPAWN;
    if(tags.contains(tag.END))return tag.END;
    return tag.TILE;
  }
  public void setSubtile(Tile t,int layer){
    if(layer == 1){
      subtiles[layer] = t;
 
      if(t.tags.contains(tag.BLACK))t.removeTag(tag.BLACK);
      if(getBaseTag()!=tag.TILE)removeTag(getBaseTag());
      if(tags.contains(tag.LINKTILE))removeTag(tag.LINKTILE);
      if(tags.contains(tag.SOLID))removeTag(tag.SOLID);
      switch(t.id){
        case 8:
          tags.add(tag.SPAWN);
          break;
        case 9:
          tags.add(tag.END);
          break;
        case 10:
          tags.add(tag.DOOR);
          tags.add(tag.SOLID);
          tags.add(tag.LINKTILE);
          break;
        case 11:
          tags.add(tag.PLATE);
          tags.add(tag.LINKTILE);
          break;
      }
      if(sc != null){
        sc.refreshTags((GameObject)this);
      }
      return;
    }
    if(layer == 2){
      if(!(tags.contains(tag.TELEPORT) || tags.contains(tag.DOOR) || tags.contains(tag.PLATE)))return;
      sc.refreshTags((GameObject)this);
      if(subtiles[1] != null){
        subtiles[1].removeTag(subtiles[1].getColorTag());
      }
      removeTag(getColorTag());
      switch(t.id){
        case 3:
          link = color(255,0,0);
          tags.add(tag.RED);
          break;
        case 4:
          link = color(0,255,0);
          tags.add(tag.GREEN);
          break;
        case 5:
          link = color(0,0,255);
          tags.add(tag.BLUE);
          break;
        case 6:
          link = color(255,255,0);
          tags.add(tag.YELLOW);
          break;
        default:
          link = color(0,0,0);
          tags.add(tag.BLACK);
      }
      if(subtiles[1]!=null){
        subtiles[1].link = link;
        subtiles[1].tags.add(getColorTag());
      }
      sc.refreshTags((GameObject)this);
    }
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
        tags.add(tag.RED);
      break;
      case 4:
        tags.add(tag.GREEN);
      break;
      case 5:
        tags.add(tag.BLUE);
      break;
      case 6:
        tags.add(tag.YELLOW);
      break;
      case 7:
        tags.add(tag.BLACK);
      break;
      case 8:
        tags.add(tag.SPAWN);
        break;
      case 9:
        tags.add(tag.END);
        break;
      case 10:
        tags.add(tag.DOOR);
        tags.add(tag.SOLID);
        break;
      case 11:
        tags.add(tag.PLATE);
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
      switch(id){
        //Ground
        case 0:
          fill(255, 255, 255, 255);
          strokeWeight(3);
          stroke(105,185,255);
          rect(x,y,w,h);
          break;
        //Wall
        case 1:
          fill(105,185,255);
          strokeWeight(3);
          stroke(105,185,255);
          rect(x,y,w,h);
          break;
        //Teleporter
        case 2:
          fill(135,135,255);
          strokeWeight(3);
          stroke(105,185,255);
          rect(x,y,w,h);
          stroke(link);
          noFill();
          circle(x+w/2,y+h/2,w/2);
          circle(x+w/2,y+h/2,w/1.5);
          circle(x+w/2,y+h/2,w/4);
          break;
        case 3:
          fill(255,0,0,133);
          strokeWeight(3);
          stroke(255,0,0);
          rect(x,y,w,h);
          break;
        case 4:
          fill(0,255,0,133);
          strokeWeight(3);
          stroke(0,255,0);
          rect(x,y,w,h);
        break;
        case 5:
          fill(0,0,255,133);
          strokeWeight(3);
          stroke(0,0,255);
          rect(x,y,w,h);
        break;
        case 6:
          fill(255,255,0,133);
          strokeWeight(3);
          stroke(255,255,0);
          rect(x,y,w,h);
        break;
        case 7:
          fill(0,0,0,133);
          strokeWeight(3);
          stroke(0,0,0);
          rect(x,y,w,h);
          break;
       //Player Spawn
       case 8:
         fill(0,255,255,183);
         strokeWeight(3);
         stroke(0,0,0);
         fill(255,255,0,183);
         beginShape();
         vertex(x+w/2,y);
         vertex(x+.66*w,y+.33*h);
         vertex(x+w,y+h/2);
         vertex(x+.66*w,y+.66*h);
         vertex(x+w/2,y+h);
         vertex(x+.33*w,y+.66*h);
         vertex(x,y+h/2);
         vertex(x+w*.33,y+h*.33);
         vertex(x+w/2,y);
         endShape();
          break;
       //End of Game
       case 9:
         fill(255);
         strokeWeight(3);
         stroke(0,0,0);
         rect(x,y,w,h);
         line(x,y,x+w,y+h);
         line(x+w,y,x,y+h);
         break;
       //Door
       case 10:
         fill(255);
         strokeWeight(3);
         rect(x,y,w,h);
         fill(0);
         stroke(0);
         rect(x+w/8,y+h/2,w*.75,h/2.5);
         noFill();
         strokeWeight(8);
         circle(x+w/2,y+h/2.7,h/2);
         fill(link,133);
         strokeWeight(3);
         stroke(link);
         rect(x-3,y-3,w+6,h+6);
         break;
       //Pressure Plate
       case 11:
         fill(link,133);
         strokeWeight(8);
         stroke(0);
         rect(x,y,w,h);
         break;
       default:
         break;
      }
      if(subtiles[1]!=null){
        subtiles[1].update();
        if(subtiles[1]!=null){
          subtiles[1].render();
        }
      }
    }else if(loadMode.equals("GAME")){
    
    }
  }
  int update() {return 0;}
  @Override
  public String toString(){
    String out="{";
    if(subtiles[1]!=null){
      out+=x+","+y+","+id+","+uid+","+w+","+h+","+getColorTag()+",";
      if(tags.contains(tag.LINKTILE)){
        LinkedTile Dupe = (LinkedTile)subtiles[1];
        out+=Dupe.toString();
      }else{
        out+=subtiles[1].toString();
      }
    }else{
      out+=x+","+y+","+id+","+uid+","+w+","+h+","+getColorTag()+","+"{}";
    }
    return out+"}";
  }
}

public class LinkedTile extends Tile{
  int linkedTile_1_uid = -1;
  int linkedTile_2_uid = -1;
  Tile link_1,link_2;
  int people_required = 1;
  //Does this tile react to other tiles, or send a signal to a tile?
  boolean reciever = false;
  boolean activated = false;
  //showColor:should this tile show it's color when running the game?
  boolean showColor=true;
  //showingColor:should the tile show it's color?(Changing this variable will change the color mid-game)
  boolean showingColor = true;
  int activate_time = 0;
  public LinkedTile(int x, int y, int id,int uid,boolean showColor){
    super(x,y,id,uid);
    this.showColor = showColor;
    tags.add(tag.LINKTILE);
  }
   public LinkedTile(int x, int y, int id,int uid,boolean showColor,int link_1_id,int link_2_id){
    super(x,y,id,uid);
    this.showColor = showColor;
    tags.add(tag.LINKTILE);
    this.linkedTile_1_uid = link_1_id;
    this.linkedTile_2_uid = link_2_id;
  }
  public LinkedTile(int x, int y, int id,int uid){
    this(x,y,id,uid,false);
  }
  public void setupLink(){
    //print(linkedTile_1_uid);
    link_1=(Tile)((LevelLoader)sc).getUID(linkedTile_1_uid);
    link_2=(Tile)((LevelLoader)sc).getUID(linkedTile_2_uid);
  }
  public void inc_time(){
    activate_time+=2;
  }
  @Override
  int update(){
    if(activate_time> 0)activate_time--;
    tag type = getBaseTag();
    if(link_1 == null){
      render();
      return super.update();
    }
    switch(type){
      case DOOR:
        //print(((LinkedTile)(link_1.subtiles[1])).activated);
        if(((LinkedTile)(link_1.subtiles[1])).activated && (link_2 == null || ((LinkedTile)(link_2.subtiles[1])).activated )){
          Tile parent = (Tile)((LevelLoader)sc).getUID(uid);
          parent.removeTag(tag.SOLID);
          parent.removeTag(tag.DOOR);
          parent.subtiles[1]=null;
          //sc.remObj(this);
          
        }
        break;
      case PLATE:
        HashSet<GameObject> player = sc.getObj(tag.PLAYER);
        Player p = null;
        if(player != null){
          for(GameObject i: player){
            p = (Player)i;
            break;
          }
          activated = p.checkCol(this);
          //print(activated);
        }else{
          activated = false;
        }
        break;
      
    }
    return super.update();
  }
  public void findLink(){
    HashSet<GameObject> pairs = sc.getObj(getColorTag());
    if(pairs != null){
      switch(id){
        case 2:
          if(pairs != null){
            for(GameObject i:pairs){
              if(linkedTile_1_uid == -1 && ((Tile)i).uid!=uid && ((Tile)i).id == id){
                linkedTile_1_uid =((Tile)i).uid;
              }
            }
          }
          break;
         case 10:
           reciever = true;
           activated = false;
           for(GameObject i:pairs){
             //print(((Tile)i).getBaseTag());
             if(linkedTile_1_uid == -1 && ((Tile)i).getBaseTag() == tag.PLATE){
               linkedTile_1_uid =((Tile)i).uid;
             }else if(linkedTile_2_uid == -1 && ((Tile)i).getBaseTag() == tag.PLATE){
               linkedTile_2_uid =((Tile)i).uid;
             }
           }
           break;
          case 11:
           reciever = false;
           activated = false;
           for(GameObject i:pairs){
             if(linkedTile_1_uid == -1 && (((Tile)i).getBaseTag() == tag.DOOR)){//The door
               linkedTile_1_uid =((Tile)i).uid;
               break;
             }
           }
          break;  
      }
    }
  }
  public void sendSignal(){
  }
  @Override
  public String toString(){
    String out="{LINKED,";
    if(subtiles[1]!=null){
      out+=x+","+y+","+id+","+uid+","+w+","+h+","+getColorTag()+","+showColor+","+activated+","+reciever+","+linkedTile_1_uid+","+linkedTile_2_uid+",";
      out+=subtiles[1].toString();
    }else{
      out+=x+","+y+","+id+","+uid+","+w+","+h+","+getColorTag()+","+showColor+","+activated+","+reciever+","+linkedTile_1_uid+","+linkedTile_2_uid+","+"{}";
    }
    return out+"}";
  }
}
