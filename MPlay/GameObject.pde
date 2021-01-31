public class GameObject {
   HashSet<tag> tags;
   Scene sc;
   GameLayer layer;
  public GameObject(){
    tags = new HashSet<tag>();
  }
  public GameObject(Scene sc){
    this.sc = sc;
    tags = new HashSet<tag>();
  }
  public GameObject(GameLayer layer){
    this.layer=layer;
    layer.add(this);
    tags = new HashSet<tag>();
  }
  public GameObject(Scene sc,GameLayer layer){
    this.sc = sc;
    this.layer=layer;
    layer.add(this);
    tags = new HashSet<tag>();
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
  void printTags(){
    print(tags);
  }
  void removeTag(tag t){
    if (tags.contains(t)){
      tags.remove(t);
    }
    if(sc!= null&&sc.objectMap.containsKey(t)){
      sc.objectMap.get(t).remove(this);
    }
  }
   int update(){
    int status = 0;
    //Do work, call Scene functions(like grab all tiles to check for collision)
    return status;
  }
  void render(){
  }
  public HashSet<tag> getTags(){
    return tags;
  }
}
