public class LevelEditor extends Scene{
  GameLayer EditLayer;
  GameLayer MidUI;
  GameLayer UI;
  EditorWindow edit;
  //Level Editor Tiles will be 64x64, Subtiles will be 48x48
  public LevelEditor(){
    EditLayer = new GameLayer(this);
    MidUI = new GameLayer(this);
    UI = new GameLayer(this);
    renderMap.add(EditLayer);
    renderMap.add(MidUI);
    renderMap.add(UI);
    MidUI.addDirect(new RectCover(0,0,1920,48,color(0)),new RectCover(0,0,48,1080,color(0)),
    new RectCover(1920-48,0,48,1080,color(0)),new RectCover(0,912,1920,1080-912,color(0)));
    SelectionButton save = new SelectionButton(1920-400,1080-150);
    save.setAction(5);
    save.toggleUse();
    edit = new EditorWindow(this,UI,EditLayer);
    UI.addDirect(edit,save,new Curtain(10));
  }
  @Override
  int update(){
    clear();
    return super.update();
  }
  protected int handleStatus(int status){
    switch(status){
      //Editor->Main Menu
      case 5:
        edit.save();
        return 1;
      default:
        return -1;
    }
  }
}
public class EditorWindow extends UI{  
  Hitbox windowView;
  Drawer borderDrawer;
  Palette[] Modifiers;
  //Current feature of level being edited
  HashMap<Integer,HashMap<Integer,Tile>>Tiles;
  final int maxModifier = 2;
  final int gtileLength = maxModifier+1;
  int currentModifier = 0;
  int brushX,brushY;
  int tileCounter = 0;
  protected boolean Ldown;
  protected boolean Rdown;
  protected boolean isHover;
  private PVector panVector;
  private GameLayer map;
  private Tile brush;
  LevelEditor editor;
  public EditorWindow(LevelEditor editor,GameLayer layer,GameLayer map){
    super(layer);
    this.editor=editor;
    this.map = map;
    Tiles = new HashMap<Integer,HashMap<Integer,Tile>>();
    windowView = new Hitbox(48,48,1824,864);
    borderDrawer = new Drawer();
    Modifiers = new Palette[5];
    //Solid Tiles
    Modifiers[0] = new Palette(this,48,940,0,3);
    //Sub Tiles(Start,Stop,Doors, Pressure Plates, Signs);
    Modifiers[1] = new Palette(this,448,940,1,10);
    //Color Editor
    Modifiers[2] = new Palette(this,848,940,2,5);
    layer.addDirect(Modifiers);
    panVector = new PVector(0,0);
    brush = new Tile(mouseX,mouseY,0,-1);
    brush.transparency = 139;
    brush.tags.remove(tag.TILE);
    brush.tags.add(tag.BRUSH);
  }
  public void setModifier(int modifier){
    Modifiers[currentModifier].disable();
    this.currentModifier = modifier;
    
  }
  public int getModifier(){
    return this.currentModifier;
  }
  public int selectionToID(int currentModifier){
    switch(currentModifier){
      case 0:
        return Modifiers[0].selection;
      case 1:
        return 8+Modifiers[1].selection;
      case 2:
        return 3+Modifiers[2].selection;
      default:
        return 0;
    }
  }
  public int update(){
    brush.setID(selectionToID(currentModifier));
    int tmpX=(Math.max(Math.min(mouseX,1872),48)-(int)map.translation.x);
    int tmpY=(Math.max(Math.min(mouseY,1872),48)-(int)map.translation.y);
    brush.x = tmpX-Math.floorMod(tmpX,64)+(int)map.translation.x;
    brush.y = tmpY-Math.floorMod(tmpY,64)+(int)map.translation.y;
    getHover();
    if(isHover){
      if(mousePressed){
        if(mouseButton == LEFT){
          brushX=tmpX;
          brushY=tmpY;
          brushX=brushX-Math.floorMod(brushX,64);
          brushY=brushY-Math.floorMod(brushY,64);
          Tile newTile;
          if(brush.id == 2 || brush.id == 10 || brush.id == 11){
            newTile = new LinkedTile(brushX,brushY,brush.id,tileCounter);
          }else{
            newTile = new Tile(brushX,brushY,brush.id,tileCounter);
          }
          newTile.layer = map;
          newTile.sc=this.sc;
          newTile.x+=6*currentModifier;
          newTile.y+=6*currentModifier;
          newTile.setH(64-12*currentModifier);
          newTile.setW(64-12*currentModifier);
          newTile.transparency =255-currentModifier*25;
          boolean canAdd = true;
          if(Tiles.containsKey(brushX)){
            HashMap<Integer,Tile> col = Tiles.get(brushX);
            if(col.containsKey(brushY)){
              if(currentModifier!=0){
                newTile.uid = col.get(brushY).uid;
                if(col.get(brushY).subtiles[currentModifier] == null || col.get(brushY).subtiles[currentModifier].id != newTile.id){
                  HashSet<GameObject> list;
                  tag new_color;
                  int tileid,counter;
                  switch(newTile.id){
                    case 8:
                      list = sc.getObj(tag.SPAWN);
                      if(list != null && list.size() > 0){
                         for(GameObject i:list){
                           ((Tile)i).subtiles[1]= null;
                           ((Tile)i).tags.remove(tag.SPAWN);
                         }
                      }
                      break;
                    case 9:
                      list = sc.getObj(tag.END);
                      if(list != null && list.size() > 0){
                         for(GameObject i:list){
                           ((Tile)i).subtiles[1]= null;
                           ((Tile)i).tags.remove(tag.END);
                         }
                      }
                      break;
                    default:
                      new_color = newTile.getColorTag();
                      tileid = col.get(brushY).id;
                      int threshold = 2;
                      if(new_color != tag.BLACK){
                        HashSet<GameObject> pairs = sc.getObj(new_color);
                        if(pairs != null && pairs.size() >= 0){
                          for(GameObject tile:pairs){
                            if(((Tile)tile).getBaseTag() == col.get(brushY).getBaseTag()){
                              if(col.get(brushY).getBaseTag() == tag.DOOR){
                                canAdd = false;
                              }
                              threshold--;
                              if(threshold == 0){
                                canAdd=false;
                                break;
                              }
                            }
                            
                          }
                        }
                      }
                      break;
                  }
                  if(canAdd){
                      col.get(brushY).setSubtile(newTile,currentModifier);
                  }
               }
              }else{
                Tile toRemove = col.get(brushY);
                if(toRemove.id != newTile.id){
                  map.removeDirect(toRemove);
                  col.put(brushY,newTile);
                  tileCounter++;
                  newTile.uid=tileCounter;
                  map.addDirect(newTile);
                }
              }
            }else{
              if(currentModifier == 0){
                col.put(brushY,newTile);
                tileCounter++;
                newTile.uid=tileCounter;
                map.addDirect(newTile);
              }
            }
          }else{
             if(currentModifier == 0){
              Tiles.put(brushX,new HashMap<Integer,Tile>());
              Tiles.get(brushX).put(brushY,newTile);
              tileCounter++;
              newTile.uid=tileCounter;
              map.addDirect(newTile);
             }
          }          
        }
        if(!Rdown){
          panVector.x = mouseX;
          panVector.y = mouseY;
        }else{
          map.dragLayer(PVector.sub(new PVector(mouseX,mouseY),panVector));
        }
      }
      if(!Rdown){
        map.setTranslation();
      }
    }
    Ldown = mousePressed && mouseButton == LEFT;
    Rdown = mousePressed && mouseButton == RIGHT;
    return 0;
  }
  public void save(){
    HashSet<GameObject> tiles = sc.getObj(tag.LINKTILE);
    if(tiles !=null){
      for(GameObject i:tiles){
          if(i instanceof LinkedTile){
           ((LinkedTile)i).findLink();
          }else{
           ((LinkedTile)((Tile)i).subtiles[1]).findLink();
          }
      }
    }
    tiles = this.sc.getObj(tag.TILE);
    String output = "";
    println(tiles);
    if(tiles== null)return;
    for(GameObject i:tiles){
      output+=(i.toString()+"\n");
    }
    PrintWriter out = createWriter("Level.txt");
    out.println(output);
    out.flush();
    out.close();
  }
  public void render(){
    if(isHover){
      brush.render();
    }
    stroke(color(100,200,255));
    borderDrawer.LineRect(windowView.TR,windowView.Dimensions,8);
  }
  boolean getHover(){return isHover=windowView.isHit(new PVector(mouseX,mouseY));}
}
public class Palette extends GameObject{
  private int x,y;
  private int id;
  private int range;
  private int selection;
  private EditorWindow canvas;
  private boolean drawType;
  private FormButton button;
  public Palette(EditorWindow s, int x, int y,int id,int range){
    canvas = s;
    this.x = x;
    this.y = y;
    this.id = id;
    this.range = range;
    this.selection=0;
    button = new FormButton(x,y,64,64);
    if(id == 0){
      button.highlighted=true;
    }
    tags.add(tag.PALETTE);
  }
  @Override
  int update(){
    button.update();
    if(canvas.getModifier() != id && button.highlighted){
      canvas.setModifier(id);
    }else{
      if(keys.isPressed('a')){
        if(--selection<0)selection = range-1;
      }
      if(keys.isPressed('d')){
        if(++selection==range)selection = 0;
      }
    }

    return 0;
  }
  void disable(){
    this.button.turnOff();
  }
  @Override
  void render(){
    button.render();
  }
}
