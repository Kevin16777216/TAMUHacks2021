GameHandler handle;
KeyListener keys = new KeyListener();
long previous = System.nanoTime();
double lag = 0.0;
HashMap<Integer,key> input = new HashMap<Integer,key>();
Networker network = null;
SpriteLoader SpriteLoader;

void setup() {
  size(1920,1080);
  frameRate(24000);
  SpriteLoader = new SpriteLoader();
  handle = new GameHandler();
}

void draw() {
  long current = System.nanoTime();
  //println("FPS: " +(int)(1E9/(current-previous)));
  previous = current;
  handle.update();
  handle.render();
  keys.update();
}

public void keyPressed() {
  keys.keyUpdate(true);
}

public void keyReleased() {
  keys.keyUpdate(false);
}
