public class Entity extends GameObject implements Physical{
  protected PVector velocity;
  protected float maxVelocity=2;
  protected boolean isActive;
  protected Hitbox box;
  protected float ACCEL_CONSTANT = 0.1;
  protected float DECCEL_CONSTANT = 0.945;
  protected Hitbox dummyBox;
  protected PImage sprite;
  int savedTime;
  int totalTime = 60000;
  String timeString = "";
  LevelLoader level;
  public Entity(Hitbox box){
    level =(LevelLoader)sc;
    this.box = box;
    velocity = new PVector(0,0);
    maxVelocity = 3;
    //sprite = loadImage("Assets/player.png");
    totalTime = 60000;
    savedTime = millis();
  }
  public Hitbox getHitbox(){
    return box;
  }
  protected boolean checkCol(Physical Bx){
    if(level == null)return false;
    Hitbox testbox = new Hitbox(PVector.add(box.TR.copy(),PVector.mult(level.TileLayer.translation,-1)),box.Dimensions.copy());
    if(Bx != null)if(testbox.isHit(Bx.getHitbox()))return true;
    return false;
  }
  protected boolean checkCol(HashSet<Physical> Boxes){
    if(Boxes != null)for(Physical i:Boxes)if(box.isHit(i.getHitbox()))return true;
    return false;
  }
  protected boolean checkEnv(HashSet<GameObject> Boxes){
    Hitbox testbox = new Hitbox(PVector.add(box.TR.copy(),PVector.mult(level.TileLayer.translation,-1)),box.Dimensions.copy());
    if(Boxes != null){
      for(GameObject i:Boxes){
        if(testbox.isHit(((Physical)i).getHitbox()))return true; 
      }
    }
    return false;
  }
  public PVector getVelocity(){
    return velocity;
  }
  protected void checkForCollision(){
    level.TileLayer.dragLayer(new PVector(PVector.mult(velocity,-1).x,0));
    level.TileLayer.setTranslation();
    //box.TR.x+= velocity.x;
    if(checkEnv(((LevelLoader)sc).getSolid())){
      level.TileLayer.dragLayer(new PVector(PVector.mult(velocity,1).x,0));
      level.TileLayer.setTranslation();
    }
    level.TileLayer.dragLayer(new PVector(0,PVector.mult(velocity,-1).y));
    level.TileLayer.setTranslation();
    if(checkEnv(((LevelLoader)sc).getSolid())){
      level.TileLayer.dragLayer(new PVector(0,PVector.mult(velocity,1).y));
      level.TileLayer.setTranslation();
    }
  }
  int update(){
    this.level =(LevelLoader)sc;
    if(velocity.mag() >= maxVelocity){
        velocity.setMag(maxVelocity);
    }
    velocity.mult(DECCEL_CONSTANT);
    checkForCollision();
    //if(velocity.mag() > .1){
    //  run.refreshNeighbor((int)(box.TR.x-box.TR.x%32)/32,(int)(box.TR.y-box.TR.y%32)/32);
    //}else{
    //  run.refreshTile((int)(box.TR.y-box.TR.y%32)/32,(int)(box.TR.x-box.TR.x%32)/32);
    //}
    return 0;
  }
}
public class Player extends Entity{
  boolean justTeleport =false;
  int teleportTime = 0;
  public Player(Hitbox box){
    super(box);
    tags.add(tag.PLAYER);
  }
  private void applyInput(){
    if(keys.isHeld('d'))velocity.x+=ACCEL_CONSTANT;
    if(keys.isHeld('a'))velocity.x-=ACCEL_CONSTANT;
    if(keys.isHeld('w'))velocity.y-=ACCEL_CONSTANT;
    if(keys.isHeld('s'))velocity.y+=ACCEL_CONSTANT;
  }
  private boolean checkExit(){
    HashSet<GameObject> exit = sc.getObj(tag.END);
    return checkEnv(exit);
  }
  private void checkTeleporters(){
    HashSet<GameObject> teleport = sc.getObj(tag.TELEPORT);
    Hitbox testbox = new Hitbox(PVector.add(box.TR.copy(),PVector.mult(level.TileLayer.translation,-1)),box.Dimensions.copy());
    if(teleport != null){
      for(GameObject i:teleport){
        if(testbox.isHit(((Physical)i).getHitbox())){
          LinkedTile portal = (LinkedTile)i;
          LinkedTile otherPortal = (LinkedTile)level.getUID(portal.linkedTile_1_uid);
          if(keys.isPressed(32)){
            if(!justTeleport){
              justTeleport =true;
              teleportTime=100;
              if(otherPortal!=null){
                level.TileLayer.dragLayer(PVector.sub(portal.getHitbox().TR,otherPortal.getHitbox().TR));
                level.TileLayer.setTranslation();
              }else{
                level.TileLayer.translation = new PVector(0,0);
                level.TileLayer.PreviousTranslation = new PVector(0,0);
                level.TileLayer.dragLayer(level.origin);
                level.TileLayer.setTranslation();
              }
            }
          }
        }
      }
    }
    
  }
  public void checkNearestSign(){
    HashSet<GameObject> signs = sc.getObj(tag.SIGN);
    if(signs!=null){
      Hitbox testbox = new Hitbox(PVector.add(box.TR.copy(),PVector.mult(level.TileLayer.translation,-1)),box.Dimensions.copy());
      for(GameObject i:signs){
        if(testbox.isHit(((Physical)i).getHitbox()) && keys.isPressed('e') && !justTeleport){
          (((Tile)i).subtiles[1]).toggle=!(((Tile)i).subtiles[1]).toggle;
          teleportTime=100;
          justTeleport =true;
        }
      }
    }
    
  }
  int update(){
    applyInput();
    super.update();
    //int passedTime = millis() - savedTime;
    //int timeLeft = totalTime - passedTime;
    //println("Time Remaining: " + timeLeft/1000 + " seconds");
 //   if(checkLava())return 1;
    checkTeleporters();
    checkNearestSign();
    if(teleportTime >0)teleportTime--;
    if(teleportTime ==0)justTeleport = false;
    if(checkExit()){
      print("done");
      return 3;
    }
  //  if(timeLeft/1000 <= 0)return 2;
    return 0;
  }
  void render(){
    box.render();
  //  image(sprite, box.getX() - 15, box.getY() - 20, box.getXSize()*2, box.getYSize()*2);
  }
}
