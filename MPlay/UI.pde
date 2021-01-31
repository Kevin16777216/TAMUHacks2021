public class Polygon extends GameObject{
  public Polygon(Scene sc,GameLayer layer){
    super(sc,layer);
  }
  void render(){
    
  }
  int update(){
    int status = 0;
    return status;
  }
}
public class UI extends GameObject{
  boolean lerp = false;
  PVector startLerp,endLerp;
  protected boolean activated = true;
  public UI(){
    tags.add(tag.UI);
  }
  public UI(GameLayer layer){
    this.layer = layer;
    tags.add(tag.UI);
  }
  void toggleUse(){
    activated = !activated;
  }
}
public class RectCover extends UI{
int x,y,dim_x,dim_y;
color rectColor;
public RectCover(int x,int y,int dim_x,int dim_y,color rectColor){
  this.rectColor = rectColor;
  this.x = x;
  this.y = y;
  this.dim_x = dim_x;
  this.dim_y = dim_y;
}
  void render(){
    fill(rectColor);
    noStroke();
    rect(x,y,dim_x,dim_y);
  }
}
public class Button extends UI{
  protected Hitbox box;
  protected boolean isHover;
  protected color borderColor = color(12);
  protected color fillColor = color(235);
  protected String text = "test";
  protected boolean down;
  protected boolean ready;
  protected PImage button_sprite;
  //Button Image Margins
  protected int button_img_x_offset;
  protected int button_img_y_offset;
  protected int button_x;
  protected int button_y;
  protected int default_action = 0;
  public Button(int x, int y, int w, int h){
    this(new Hitbox(new PVector(x,y),new PVector(w,h)));
  }
  public Button(Hitbox box){
    this(box,0);
  }
  public Button(Hitbox box,int action){
    this(box,action,true);
  }
  public Button(Hitbox box,int action,boolean activated){
    this.box = box;
    this.default_action=action;
    this.activated=activated;
    tags.add(tag.BUTTON);
  }
  
  void setButtonSprite(String img_name, int x_loc, int y_loc){
    button_sprite = loadImage(img_name);
    button_img_x_offset = x_loc;
    button_img_y_offset = y_loc;
  }
 
  
  int update(){
    int status = 0;
    isHover = box.isHit(new PVector(mouseX,mouseY));
    if(isHover && mousePressed && !down && activated){
      status = action();
    }
    down = mousePressed;
    return status;
  }

  boolean getHover(){return isHover=box.isHit(new PVector(mouseX,mouseY));}
  int action(){return default_action;}
  void setAction(int status){
    default_action = status;
  }
  void render(){
    if(button_sprite != null) {
      image(button_sprite,box.TR.x+button_img_x_offset,box.TR.y+button_img_y_offset,
           box.Dimensions.x-2*button_img_x_offset,box.Dimensions.y-2*button_img_y_offset);
    }
    else{
      rect(box.TR.x,box.TR.y,box.Dimensions.x,box.Dimensions.y);
    }
  }
}
public class SelectionButton extends Button{
  Drawer draw;
  PVector[] outline;
  color UnselectedColor = color(135,135,255);
  color SelectedColor = color(255,135,0);
  static final int DEFAULT_SIZE_X = 700;
  static final int DEFAULT_SIZE_Y = 150;
  public SelectionButton(int x, int y, int w, int h){
    this(new Hitbox(new PVector(x,y),new PVector(w,h)));
  }
  public SelectionButton(Hitbox box){
    super(box);
    draw = new Drawer();
    outline = new PVector[5];
    outline[0]=new PVector(box.TR.x,box.TR.y);
    outline[1]=new PVector(box.TR.x+box.getXSize(),box.TR.y);
    outline[2]=new PVector(box.TR.x+box.getXSize(),box.TR.y+box.getYSize());
    outline[3]=new PVector(box.TR.x,box.TR.y+box.getYSize());
    outline[4]=new PVector(box.TR.x,box.TR.y);
  }
  public SelectionButton(int x, int y){
    this(x,y,DEFAULT_SIZE_X,DEFAULT_SIZE_Y);
  }
  @Override
  void render(){
    if(isHover){
      draw.DrawDottedPoly(outline,.5,8,300,8,true,true,SelectedColor,color(255));
    }else{
      draw.DrawDottedPoly(outline,.5,8,300,8,true,true,UnselectedColor,color(255));
    }
    if(button_sprite != null) {
      image(button_sprite,box.TR.x+button_img_x_offset,box.TR.y+button_img_y_offset,box.Dimensions.x-2*button_img_x_offset,box.Dimensions.y-2*button_img_y_offset);
    }
  }
}
public class FormButton extends SelectionButton{
  boolean highlighted = false;
  color HighlightedColor = color(0,255,0);
  public FormButton(int x, int y, int w, int h){
    super(x,y,w,h);
  }
  @Override
  int update(){
    isHover = box.isHit(new PVector(mouseX,mouseY));
    if(isHover && mousePressed && !down && !highlighted){
      highlighted = true;
    }
    down = mousePressed;
    return 0;
  }
  void turnOff(){
     highlighted = false;
  }
  @Override
  void render(){
    if(isHover){
      draw.DrawDottedPoly(outline,.5,8,300,8,true,true,SelectedColor,color(255));
    }else if (highlighted){
      draw.DrawDottedPoly(outline,.5,8,300,8,true,true,HighlightedColor,color(255));
    }else{
      draw.DrawDottedPoly(outline,.5,8,300,8,true,true,UnselectedColor,color(255));
    }
    if(button_sprite != null) {
      image(button_sprite,box.TR.x+button_img_x_offset,box.TR.y+button_img_y_offset,box.Dimensions.x-2*button_img_x_offset,box.Dimensions.y-2*button_img_y_offset);
    }
  }
  
}
public class Curtain extends UI{
  float clearspeed;
  float life = 255;
  public Curtain(float clearspeed){
     this.clearspeed = clearspeed;
  }
  int update(){
    if(life <= 0){
      HashSet<GameObject> UI = sc.getObj(tag.UI);
      for(GameObject i:UI){
        if(i instanceof UI){
          ((UI)i).activated=true;
        }     
      }
      layer.removeDirect(this);
    }
    life-=clearspeed;
    return 0;
  }
  void render(){
    noStroke();
    fill(255,255,255,life);
    rect(0,0,width,height);
  }
}

public class menuCurtain extends UI{
  float a = 0.0;
  float inc = TWO_PI/25.0;
  float prev_x = 0, prev_y = -40, x, y;
  float starty=-40, startyBack = 1120;
  boolean check;
  
  //public menuCurtain(boolean check){
  //  this.check=check;
  //}
  
  void setBackground(){
    if(starty==-40){
      background(201,241,255);
    }
  }
  
  int update(){
    //1076,1067
    if(starty >= 1076.0){
      
      HashSet<GameObject> UI = sc.getObj(tag.UI);
      for(GameObject i:UI){
        if(i instanceof UI){
          ((UI)i).activated=true;
        }     
      }
      layer.removeDirect(this);
      //check=true;
    }
    return 0;
  }
  
  void CurtainLine(){
    background(201,241,255);
    //println(starty);
    //draws individual line across screen using sin wave
    for(int i=0; i<1920; i=i+4) {
      x = i;
      y = starty + 0.4*sin(a) * 40.0;
      line(prev_x, prev_y, x, y);
      prev_x = x;
      prev_y = y;
      a = a + inc;
      if(a%TWO_PI>(PI/2) && a%TWO_PI<(3*PI/2)){
        stroke(233, 88, 88);
      }
      else{
        stroke(255, 112, 112);
      }
    }
  }
  //irrelevent
  void render(){
    
    if(starty<1080.0){
      //draws sets of lines
      for(int i=0;i<10;i++){
        CurtainLine();
        a=0.0;
        prev_x=0;
        starty+=3;
        prev_y += 3;
        
      }
    }
    //else{
    //  background(201,241,255);
    //  fill(0);
    //  textSize(50);
    //  textAlign(CENTER);
    //  text("Main Menu", 640, 360);
    //}
  }
}

public class WaitingAnimation extends UI{
  float t;
  
  float r(float theta, float a, float b, float m, float n1, float n2, float n3){
  return pow(pow(abs(cos(m * theta / 4.0) / a), n2) + pow(abs(sin(m * theta / 4.0) / b), n3), -1.0 / n1);
  }
  
  
  void render(){
    noFill();
    stroke(255);
    strokeWeight(2);
    translate(width/2, height/2+50);
    background(0);
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
}
//Class for those Fancy effects
public class Drawer{
  void LineRect(PVector a, PVector b,int strokeWeight){
    noFill();
    strokeWeight(strokeWeight);
    rect(a.x,a.y,b.x,b.y);
  }
  float LineSlope(int x1, int y1, int x2, int y2){
    return (y2-y1)/(x2-x1);
  }
  float LineLength(float x1, float y1, float x2, float y2){
    return sqrt(pow((x1-x2),2) +pow((y1-y2),2));
  }
  void DrawDottedPoly(PVector[] Coords, float frac, int segments, int frames,int pressure,boolean animated,boolean fill,color StrokeColor,color FillColor){
    //frac:The faction of the line to be filled in
    //segements:The number of dotted lines
    //frames:How smooth(slow/fast) the animation is
    //pressure:Line thickness
    //animated:Whether dotted line is animated
    //fill:Whether the coordinates represent an enclosed shape
    int sides = Coords.length-1;
    if(sides < 1)return;
    strokeWeight(pressure);
    float[] sidesLengths = new float[sides];
    float Perimeter = 0;
    for(int i = 1;i<Coords.length;i++){
      float sidelength = LineLength(Coords[i-1].x,Coords[i-1].y,Coords[i].x,Coords[i].y);
      Perimeter += sidelength;
      sidesLengths[i-1] = sidelength;
    }
    if(fill == true){
      noStroke();
      fill(FillColor); 
      beginShape(); 
       for (int i = 0; i < sides; i++){
          vertex(Coords[i].x,Coords[i].y);
       } 
      endShape(); 
    }
    stroke(StrokeColor);
    if(animated){
    //--Everything beyond here can be used for only enclosed shape
      float SegmentLength = Perimeter*frac/segments;
      float SpaceLength = Perimeter*(1-frac)/segments;
      //Animation goes from 0->1 cyclical.
      float time = (millis()%frames);
      time /= frames;
      float offset;
      boolean drawing;
      if(time <= 1-frac){
        offset = SpaceLength*(1-time/(1-frac));
        drawing = false;
      }else{
        offset= SegmentLength*((1-time)/frac);
        drawing=true;
      }
      for(int i = 0;i<sides;i++){
        PVector current = Coords[i].copy();
        PVector next = Coords[i+1].copy();
        boolean goNextLine = false;
        PVector dash;
        float distanceLeft = PVector.sub(next,current).mag();
        if(drawing == true){
          dash = PVector.sub(next,current).setMag(SegmentLength-offset);
        }else{
          dash = PVector.sub(next,current).setMag(SpaceLength-offset);
        }
        if(dash.mag() > distanceLeft){
          if(drawing){
            line(current.x,current.y,next.x,next.y);
          }
          if(dash.mag() == distanceLeft){
            drawing=!drawing;
            offset=0;
          }else{
            offset+=sidesLengths[i];
          }
          goNextLine = true;
        }
        while(!goNextLine){
          if(drawing){
            PVector end_dash = PVector.add(current,dash);
            line(current.x,current.y, end_dash.x,end_dash.y); 
          }
          offset=0;
          current.add(dash);
          distanceLeft-=dash.mag();
          drawing=!drawing;
          if(drawing == true){
            dash = PVector.sub(next,current).setMag(SegmentLength);
          }else{
            dash = PVector.sub(next,current).setMag(SpaceLength);
          }
          if(dash.mag() >= distanceLeft){
            if(drawing){
              line(current.x,current.y,next.x,next.y);
            }
            if(dash.mag() == distanceLeft){
              drawing=!drawing;
              offset=0;
            }else{
              dash.setMag(distanceLeft);
              offset+=distanceLeft;
            }
            goNextLine = true;
          }
       }
      }
    }
  }
}
