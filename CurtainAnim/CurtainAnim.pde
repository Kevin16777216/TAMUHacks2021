float a = 0.0;
float inc = TWO_PI/25.0;
float prev_x = 0, prev_y = -40, x, y;
float starty=-40;

void setup(){
  size(1280,720);
  strokeWeight(4);
  stroke(255, 112, 112);
  
}

void draw(){
  
  if(y<720.0){
    for(int i=0;i<3;i++){
      CurtainLine();
      a=0.0;
      prev_x=0;
      starty+=3;
      prev_y += 3;
    }
  }
  else{
    background(201,241,255);
    fill(0);
    textSize(50);
    textAlign(CENTER);
    text("Main Menu", 640, 360);
  }
  
}

void CurtainLine(){
  for(int i=0; i<1280; i=i+4) {
    x = i;
    y = starty + sin(a) * 40.0;
    line(prev_x, prev_y, x, y);
    prev_x = x;
    prev_y = y;
    a = a + inc;
  }
}
