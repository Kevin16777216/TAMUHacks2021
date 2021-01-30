import ddf.minim.*;
import ddf.minim.analysis.*;

AudioClipComparator Bonobo;
boolean match = false;

void setup()
{
  size(1024, 200, P2D);
  Bonobo = new AudioClipComparator(this);
}

void draw()
{
  background(0);
  stroke(255);
  text( "AudioClipComparator is currently " + Bonobo.state , 5, 15 );
  text("is matching? "+ match, 10, 30);
}

void keyPressed() { 
  if ( key == 'r' || key == 'R' ) { 
     Bonobo.recordSrc();
  } 
  if ( key == 's' || key == 'S' ) { 
     Bonobo.recordSecond();
  }
  if ( key == 'c' || key == 'C' ) { 
     match = Bonobo.compareFreqClip();
  } 
  
} 

void stop()
{
  // always close Minim audio classes when you are done with them
  super.stop();
}
