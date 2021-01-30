interface Physical{
  public Hitbox getHitbox();
}
public class Hitbox{
  //Coordinate(Top Right);
  PVector TR;
  //Dimensions
  PVector Dimensions;
  public Hitbox(PVector TR, PVector Dimensions){
     this.TR = TR;
     this.Dimensions = Dimensions;
  }
  public Hitbox(int x, int y,int dx,int dy){
    this(new PVector(x,y),new PVector(dx,dy));
  }
  public boolean isHit(Hitbox other){
   if (other != this){
      if (TR.x <= (other.TR.x + other.Dimensions.x) &&
         TR.y <= (other.TR.y + other.Dimensions.y) &&
         (TR.x + Dimensions.x) >= other.TR.x   &&
         (TR.y + Dimensions.y) >= other.TR.y){
          return true;
         }
   }
   return false;
  }
  public boolean isHit(PVector other){
    return other.x>=TR.x && other.y>=TR.y && other.x<=TR.x+Dimensions.x && other.y<=TR.y+Dimensions.y;
  }
  public void translate(PVector diff){
    this.TR.add(diff);
  }
  void render(){
    rect(TR.x,TR.y,Dimensions.x,Dimensions.y);
  }
  
  public int getX() {
    return (int)TR.x;
  }
  public int getY() {
    return (int)TR.y;
  }
  public int getXSize() {
    return (int)Dimensions.x;
  }
  public int getYSize() {
    return (int)Dimensions.y;
  }
}
