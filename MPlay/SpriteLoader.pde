public class SpriteLoader {
  HashMap<String, PImage> floorSprites;
  public SpriteLoader() {
    floorSprites = new HashMap<String, PImage>();
  }
  
  public PImage getImage(String name){
    return floorSprites.get(name);
  }
  public PImage getTile(int id){
    return null;
  }
}
