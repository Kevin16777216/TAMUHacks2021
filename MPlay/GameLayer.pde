public class GameLayer extends GameObject{
    
  private HashSet<GameObject> objects = new HashSet<GameObject>();
  PVector translation = new PVector(0,0);
  PVector PreviousTranslation = new PVector(0,0);
  boolean freezePosition = true;
  public GameLayer(Scene sc) {
    super(sc);
    this.layer=this;
  }

  public GameLayer(PVector translation) {
    this.translation = translation;
  }
  public void dragLayer(PVector translation){
    this.translation = PVector.add(PreviousTranslation,translation);
    freezePosition = false;
  }
  public void setTranslation(){
    this.PreviousTranslation = translation;
    freezePosition = true;
  }
  public void drawLayer() {
    pushMatrix();
    translate(translation.x,translation.y);
    for(GameObject i:objects) {
      i.render();
    }
    popMatrix();
  }

  public void add(GameObject... item) {
    for(GameObject i :item){    
      if(!objects.contains(i)){
        objects.add(i);
      }
    }
  }
  public void addDirect(GameObject ...item) {
    for(GameObject i :item){
      if(i==null)continue;
      if(!objects.contains(i)){
        objects.add(i);
      }
      try{
        i.linkSC(sc);
        i.linkLayer(this);
        sc.addObj(i);
      }catch(Exception e){
        e.printStackTrace();
      }
    }
  }
  public void remove(GameObject... item){
    for(GameObject i :item){    
      objects.remove(i);
    }
  }
  public void removeDirect(GameObject... item){
    for(GameObject i :item){    
      objects.remove(i);
      sc.remObj(i);
    }
  }
  public void shiftTranslation(PVector shift) {
    translation.add(shift);
  }

}
