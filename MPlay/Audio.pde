import ddf.minim.*;
import ddf.minim.analysis.*;

public class AudioClipComparator {
  //can be made private to class
  Minim minim;
  AudioInput in;
  FFT srcFft, secondFft;
  int bufferSize= 262144;//currently 2.97 seconds fron toggle on
  int sampleRate = 44100;
  int soundFloor = 30;
  int srcFrq=-1, secondFrq=-2;
  AudioBuffer srcAbuff, secondAbuff;
  //for recordings
  javax.sound.sampled.AudioFormat buffFormat;
  //can be useful outside of class
  String state = "Missing Resource";
  boolean minimOn = false;
  PApplet app;
  
  //<-------------------------------------Constructor---------------------------------->
  public AudioClipComparator(PApplet application){
    app = application;
  }
  //<----------------------------------Public Functions-------------------------------->
  //Make sure to toggle on before any input by at least buffer length, turns on/off minim inputStream
  public void toggleMinim(){
    if(minimOn){
      // always close Minim audio classes when you are done with them
      in.close();
      minim.stop(); 
      minimOn = false;
      println("turned off");
    }
    else{
      minim = new Minim(app);
      in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate, 16);
      buffFormat = in.getFormat();
      minimOn = true;
      println("turned on");
    }
  }
  
  //This allows record function to cut off current buffer and save to a variable
  private void minimOff(){
      in.close();
      minim.stop(); 
      minimOn = false;
      println("turned off");
      toggleMinim();
  }
  
  //record clip A to srcAbuff (toggleMinim On 2.97 sec before this, then call this to record 2.97sec)
  public void recordSrc(){
    if(!minimOn) toggleMinim();
    srcAbuff = in.mix; 
    println("wroteToSrc");
    minimOff();
  }
  
  //record clip B to secondAbuff
  public void recordSecond(){
    if(!minimOn){toggleMinim();}
    secondAbuff = in.mix;
    println("wroteToSecond");
    minimOff();
  }
  
  public void playA(){
    AudioSample playback = minim.createSample(srcAbuff.toArray(), buffFormat, bufferSize);
    playback.trigger();
  }
  public void playB(){
    AudioSample playback = minim.createSample(secondAbuff.toArray(), buffFormat, bufferSize);
    playback.trigger();
  }
  
  //compare A and B freq
  public boolean compareFreqClip(){
    println("loudest source freq is ");
    srcFrq=-1;
    srcFrq = getFrq(srcAbuff);
    println("loudest submitted freq is ");
    secondFrq=-2;
    secondFrq = getFrq(secondAbuff);
    state = "Complete";
    if(Math.abs(srcFrq-secondFrq)<10) return true;
    return false;
  }
  
  
  
  //<----------------------------------Private Functions-------------------------------->
  
  private int getFrq(AudioBuffer ab){
    FFT abFft = new FFT(bufferSize, sampleRate);
    int highest=0;
    int abFrq=0;
    abFft.forward(ab);
    println("sec len: " + abFft.specSize());
    for (int n = 0; n < abFft.specSize(); n++) {
      if (abFft.getBand(n)>abFft.getBand(highest)) highest=n;
    }
    if(abFft.getBand(highest)>soundFloor){
      abFrq = calcHz(highest);
      println(abFrq +"hz @"+abFft.getBand(highest));
    }
    return abFrq;
  }
  
  private int calcHz(int highest){
    return int(highest/float(bufferSize) * sampleRate);
  }
  
  
  
}
