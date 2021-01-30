public class GameObject {
   ArrayList<tag> tags;
   Scene sc;
   GameLayer layer;
  public GameObject(){
    tags = new ArrayList<tag>();
  }
  public GameObject(Scene sc){
    this.sc = sc;
    tags = new ArrayList<tag>();
  }
  public GameObject(GameLayer layer){
    this.layer=layer;
    layer.add(this);
    tags = new ArrayList<tag>();
  }
  public GameObject(Scene sc,GameLayer layer){
    this.sc = sc;
    this.layer=layer;
    layer.add(this);
    tags = new ArrayList<tag>();
  }
  void linkSC(Scene sc){
    this.sc = sc;
  }
  void linkLayer(GameLayer layer){
    this.layer = layer;
  }
  void link(Scene sc,GameLayer layer){
    this.sc = sc;
    this.layer = layer;
  }
  int update(){
    int status = 0;
    //Do work, call Scene functions(like grab all tiles to check for collision)
    return status;
  }
  void render(){
  }
  public ArrayList<tag> getTags(){
    return tags;
  }
}
