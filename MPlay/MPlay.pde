GameHandler handle;
KeyListener keys = new KeyListener();
long previous = System.nanoTime();
PFont mono;
double lag = 0.0;
HashMap<Integer,key> input = new HashMap<Integer,key>();
Networker network = null;
SpriteLoader SpriteLoader;

void setup() {
  size(1920,1080);
  frameRate(60);
  SpriteLoader = new SpriteLoader();
  handle = new GameHandler();
  mono = createFont("Moon Light.otf", 32);
  textFont(mono);
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
