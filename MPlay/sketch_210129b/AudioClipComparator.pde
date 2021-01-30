import ddf.minim.*;
import ddf.minim.analysis.*;

public class AudioClipComparator {
  Minim minim;
  AudioInput in;
  FFT srcFft, secondFft;
  int bufferSize= 65536;
  int sampleRate = 44100;
  int soundFloor = 0;
  int srcFrq=0, secondFrq=1;
  float[] srcBuffer;
  float[] secondBuffer;
  javax.sound.sampled.AudioFormat srcFormat, secondFormat;
  String state = "Missing Resource";
  PApplet app;
  
  
  public AudioClipComparator(PApplet application){
    app = application;
  }
  
  public void recordSrc(){
    minim = new Minim(app);
    //minim.debugOn();
    in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
    while(in.mix.size()< bufferSize);
    srcBuffer = in.mix.toArray();
    srcFormat = in.getFormat();
    println("wroteToSrc");
    
    in.close();
    minim.stop();
  }
  
  public void recordSecond(){
    minim = new Minim(app);
    //minim.debugOn();
    in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
    while(in.mix.size()< bufferSize);
    
    secondBuffer = in.mix.toArray();
    secondFormat = in.getFormat();
    println("wroteToSecond");
    
    in.close();
    minim.stop();
  }
  
  public boolean compareFreqClip(){
    minim = new Minim(app);
    //minim.debugOn();
    
    AudioSample src = minim.createSample(srcBuffer, srcFormat,bufferSize);
    AudioSample second = minim.createSample(secondBuffer, secondFormat,bufferSize);
    
    srcFft = new FFT(bufferSize, sampleRate);
    secondFft = new FFT(bufferSize, sampleRate);
    
    int srcHighest=0;
    srcFft.forward(src.mix);
    println("src len: " + srcFft.specSize());
    for(int n = 0; n < srcFft.specSize(); n++) {
      //find frequency with highest amplitude
      if (srcFft.getBand(n)>srcFft.getBand(srcHighest)) srcHighest=n;
    }
    println(srcHighest);
    if(srcFft.getBand(srcHighest)>soundFloor){
      srcFrq = calcHz(srcHighest);
      println(srcFrq);
    }
    
    int secondHighest=0;
    secondFft.forward(second.mix);
    println("sec len: " + secondFft.specSize());
    for (int n = 0; n < secondFft.specSize(); n++) {
      //find frequency with highest amplitude
      if (secondFft.getBand(n)>secondFft.getBand(secondHighest)) {secondHighest=n;}
    }
    println(secondHighest);
    if(secondFft.getBand(secondHighest)>soundFloor){
      secondFrq = calcHz(secondHighest);
      println(secondFrq);
    }
    
    src.close();
    second.close();
    minim.stop();  
    
    state = "Complete";
    if(Math.abs(srcFrq-secondFrq)<10){
      return true;
    }
    return false;
  }
  
  private int calcHz(int highest){
    return int(highest/float(bufferSize) * sampleRate);

  }
  
}
