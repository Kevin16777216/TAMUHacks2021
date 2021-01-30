float a = 0.0;
float inc = TWO_PI/25.0;
float prev_x = 0, prev_y = 70, x, y;

void setup(){
  size(1280,720);
  for(int i=0; i<1280; i=i+4) {
  x = i;
  y = 50 + 0.3*sin(a) * 40.0;
  line(prev_x, prev_y, x, y);
  prev_x = x;
  prev_y = y;
  a = a + inc;
  }
}

void draw(){
  
  
}
