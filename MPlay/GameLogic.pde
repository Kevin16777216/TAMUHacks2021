public static enum Status{
  ERROR,
  GOOD,
}
public class GameHandler {
  final int DEFAULT_SCENE = 0;
  int resp;
  String lvlData = "";
  Scene cScene;
  Status state = Status.GOOD;
  public GameHandler() {
    loadScene(DEFAULT_SCENE);
  }
  private Scene getScene(int id) {
    switch (id) {
      case 0:
        return new Scene_Main_Menu();
      case 1:
      case 2:
      case 3:
      case 4:
        return new LevelEditor();
      default:
        break;
    }
    return null;
  }
  private void loadScene(int id) {
    cScene = getScene(id);
  }

  private void handleSignal(int code) {
    switch (code) {
      case -1:
        cScene.exit();
        exit();
      default:
        //clean up other garbage
        cScene.exit();
        //load new Scene
        loadScene(code);
        break;
    }
  }
  public void update() {
    this.resp = this.cScene.update();
    //If scene returns 0, means normal operation This also means that people should never reach demo scene.
    if (this.resp!=0) {
      this.handleSignal(this.resp);
    }
  }
  public void render(){
    cScene.render();
  }
}
