float t;
void setup(){
  size(1280,720);
  
  textSize(32);

 
}
void draw(){
  background(0);
  textAlign(CENTER);
  text("Temp Waiting Text", width/2, 100); 
  fill(255, 255, 255);
  
  noFill();
  stroke(255);
  strokeWeight(2);
  translate(width/2, height/2+50);
  //creates shape each frame
  beginShape();
  for(float theta = 0; theta < 2*PI; theta += 0.01){
    //float rad = r(theta,mouseX/100.0,mouseY/100.0,8,1,1,1);
    float rad = r(theta,2,2,10,1,sin(t) * 0.5 +0.5, cos(t) * 0.5 +0.5);
    float x = rad * cos(theta)*50;
    float y = rad * sin(theta)*50;
    vertex(x,y);
  }
  
  endShape();
  //use t for non mouse inputs
  t+=0.1;
}
//m determines how many spikes
float r(float theta, float a, float b, float m, float n1, float n2, float n3){
  return pow(pow(abs(cos(m * theta / 4.0) / a), n2) + pow(abs(sin(m * theta / 4.0) / b), n3), -1.0 / n1);
  
}
