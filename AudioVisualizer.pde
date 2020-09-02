import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;

int numBall = 60;
int numBallzzz = 60;
Ball balls[] = new Ball[numBallzzz];
Bar bars[] = new Bar[numBall];

Border b1;
Border b2;
Border b3;
Border b4;

Border b5;
Border b6;

Border b7;
Border b8;

int depth = 2000;
int borderWidth = 3;
int barWidth = 10;
int barMinHeight = 20;
int maxBoxOutline = 5;
float rotation = 0.0;

float average = 0.0;

float lowAvg = 0.0;
float midAvg = 0.0;
float highAvg = 0.0;

float OldlowAvg = 0.0;
float OldmidAvg = 0.0;
float OldhighAvg = 0.0;

float lowRange = 0.05;
float midRange = 0.25;
float highRange = 1.0;

Triangles coolStuff;


void setup(){
  fullScreen(P3D);
  
  minim = new Minim(this);
  
  b1 = new Border(width - borderWidth, borderWidth/2         , 0, 0, 0, depth);
  b2 = new Border(width - borderWidth, height - borderWidth/2, 0, 0, 0, depth);
  b3 = new Border(borderWidth/2      , borderWidth/2         , 0, 0, 0, depth);
  b4 = new Border(borderWidth/2      , height-borderWidth/2  , 0, 0, 0, depth);
  
  b5 = new Border(width/2, 0                    , -depth, width - borderWidth*2, 0, 0);
  b6 = new Border(width/2, height - borderWidth/2, -depth, width - borderWidth*2, 0, 0);
  
  b7 = new Border(0                    , height, -depth, 0, height - borderWidth, 0);
  b8 = new Border(width - borderWidth/2, height, -depth, 0, height - borderWidth, 0);

  
  
  song = minim.loadFile("sound.mp3");
  fft = new FFT(song.bufferSize(), song.sampleRate());
  song.play();
  
  for(int i = 0; i < numBallzzz; i++){
    balls[i] = new Ball(int(random(10, 20)));
    balls[i].setPos(int(random(0, width)), int(random(0, height)), -depth - int(random(-2000,2000)));
  }
  
  for(int i = 0; i < numBall; i++){
    bars[i] = new Bar();
    bars[i].setPos(width, height/2, -depth + i*50);
  }
  
  coolStuff = new Triangles();
}

void draw(){
  background(0);
  
  stroke(255);
  fft.forward(song.mix);
  
  average = 0.0;
  lowAvg = 0.0;
  midAvg = 0.0;
  highAvg = 0.0;
  int theSize = fft.specSize();
  
  for(int i = 0; i < int(theSize*lowRange); i++){
    lowAvg += fft.getBand(i);
  }
  for(int i = int(theSize*lowRange); i < int(theSize*midRange); i++){
    midAvg += fft.getBand(i);
  }
  
  for(int i = int(theSize*midRange); i < int(theSize*highRange); i++){
    highAvg += fft.getBand(i);
  }
  
  average = lowAvg + midAvg + highAvg;
  average /= 1000.0;
  lowAvg /= (1000.0*lowRange);
  midAvg /= (1000.0*midRange - 1000.0*lowRange);
  highAvg /= (1000.0*highRange - 1000.0*midRange);
  
  if(OldlowAvg == 0.0){
    OldlowAvg = lowAvg;
  }
  if(OldmidAvg == 0.0){
    OldmidAvg = midAvg;
  }
  if(OldhighAvg == 0.0){
    OldhighAvg = highAvg;
  }
  
  lowAvg = (lowAvg + OldlowAvg) / 2;
  midAvg = (midAvg + OldmidAvg) / 2;
  highAvg = (highAvg + OldhighAvg) / 2;
  
  for(int i = 0; i < numBall; i++){
    bars[i].display(i);
  }
  
  for(int i = 0; i < numBallzzz*lowRange; i++){
    balls[i].display(i, lowAvg);
  }
  
  for(int i = int(numBallzzz*lowRange); i < int(numBallzzz*midRange); i++){
    balls[i].display(i, midAvg);
  }
  
  for(int i = int(numBallzzz*midRange); i < int(numBallzzz*highRange); i++){
    balls[i].display(i, highAvg);
  }

  b1.display();
  b2.display();
  b3.display();
  b4.display();
  
  b5.display();
  b6.display();
  
  b7.display();
  b8.display();
  
  coolStuff.display();
  
  OldlowAvg = lowAvg;
  OldmidAvg = midAvg;
  OldhighAvg = highAvg;

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




class Triangles{
  int points = 0;
  //Bar bars[] = new Bar[numBall];
  Triangles(){
    this.points = numBall;
  }
  
  void display(){
    //translate(this.x, this.y, this.z);
    //box(average*barWidth, barMinHeight + int(fft.getBand(i)*4), average*barWidth);
    //translate(-this.x, -this.y, -this.z);
    
    for(int i = 0; i < points; i++){
      colorMode(HSB, average * numBall);
      noStroke();
      fill(i, i, 100);
      
      int stuff = barMinHeight + int(fft.getBand(i)*4);
      
      // top left
      
      translate(0, stuff/4, -depth + i*50);
      box(average*barWidth, stuff/2, average*barWidth);
      translate(0, -stuff/4, -(-depth + i*50));
      
      translate(stuff/4, 0, -depth + i*50);
      box(stuff/2, average*barWidth, average*barWidth);
      translate(-stuff/4, 0, -(-depth + i*50));
      
      //bottom left
      
      translate(0, height - stuff/4, -depth + i*50);
      box(average*barWidth, stuff/2, average*barWidth);
      translate(0, -(height - stuff/4), -(-depth + i*50));
      
      translate(stuff/4, height, -depth + i*50);
      box(stuff/2, average*barWidth, average*barWidth);
      translate(-stuff/4, -(height), -(-depth + i*50));
      
      
      // top right
      
      translate(width, stuff/4, -depth + i*50);
      box(average*barWidth, stuff/2, average*barWidth);
      translate(-width, -stuff/4, -(-depth + i*50));
      
      translate(width - stuff/4, 0, -depth + i*50);
      box(stuff/2, average*barWidth, average*barWidth);
      translate(-(width - stuff/4), 0, -(-depth + i*50));
      
      // bottom right
      
      translate(width, height - stuff/4, -depth + i*50);
      box(average*barWidth, stuff/2, average*barWidth);
      translate(-width, -(height - stuff/4), -(-depth + i*50));
      
      translate(width - stuff/4, height, -depth + i*50);
      box(stuff/2, average*barWidth, average*barWidth);
      translate(-(width - stuff/4), -height, -(-depth + i*50));
      
      noFill();
    }
  
  }


}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Bar{
  int x;
  int y;
  int z;
  
  Bar(){
    
  }
  
  void setPos(int x,int y,int z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  void display(int i){
    colorMode(HSB, average * numBall);
    noStroke();
    fill(i, i, 100);

    translate(this.x, this.y, this.z);
    box(average*barWidth, barMinHeight + int(fft.getBand(i)*4), average*barWidth);
    translate(-this.x, -this.y, -this.z);
    
    translate(0, this.y, this.z);
    box(average*barWidth, barMinHeight + int(fft.getBand(i)*4), average*barWidth);
    translate(0, -this.y, -this.z);
    
    translate(this.x/2, this.y*2, this.z);
    box(barMinHeight + int(fft.getBand(i)*5), average*barWidth , average*barWidth);
    translate(-this.x/2, -this.y*2, -this.z);
    
    translate(this.x/2, 0, this.z);
    box(barMinHeight + int(fft.getBand(i)*5), average*barWidth , average*barWidth);
    translate(-this.x/2, 0, -this.z);
    noFill();
  }

}

class Border{
  int x;
  int y;
  int z;
  int lenx;
  int leny;
  int lenz;
  Border(int x, int y, int z, int lenx, int leny, int lenz){
    this.x = x;
    this.y = y;
    this.z = z;
    this.lenx = lenx;
    this.leny = leny;
    this.lenz = lenz;
  }
  
  void display(){
    noStroke();
    fill(numBall, numBall,100);
    translate(this.x, this.y - this.leny/2, this.z - this.lenz/2);
    box(borderWidth+this.lenx, borderWidth+this.leny, this.lenz);
    translate(-(this.x), -(this.y - this.leny/2), -(this.z- this.lenz/2));
  }
}



class Ball{
  int r;
  int x;
  int y;
  int z;
  float rot = 0.0;
  
  Ball(int r){
    this.r = r;
    this.rot = 0.0;
  }
  
  void setPos(int x,int y,int z){
    this.x = x;
    this.y = y;
    this.z = z;
    this.rot = random(0, 614) / 100;
  }
  
  void display(int i, float avg){
    noStroke();
    colorMode(HSB, average*numBallzzz);
    fill(i, i, 100, 120);
    rotateZ(this.rot);
    //rotateX(this.rot);
    translate(this.x, this.y, this.z);
    //sphere(avg * this.r);
    //box(avg * this.r, avg * this.r, avg * this.r);
    translate(-this.x, -this.y, -this.z);
    
    float offset = avg * this.r;
    int theBorder = int(avg*maxBoxOutline);
    
    
    translate(this.x-offset, this.y-offset, this.z);
    box(theBorder, theBorder, 2*avg*this.r);
    translate(-(this.x-offset), -(this.y-offset), -this.z);
    
    translate(this.x+offset, this.y+offset, this.z);
    box(theBorder, theBorder, 2*avg*this.r);
    translate(-(this.x+offset), -(this.y+offset), -this.z);
    
    translate(this.x+offset, this.y-offset, this.z);
    box(theBorder, theBorder, 2*avg*this.r);
    translate(-(this.x+offset), -(this.y-offset), -this.z);
    
    translate(this.x-offset, this.y+offset, this.z);
    box(theBorder, theBorder, 2*avg*this.r);
    translate(-(this.x-offset), -(this.y+offset), -this.z);
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    translate(this.x, this.y+offset, this.z+offset);
    box(2*avg*this.r + theBorder, theBorder, theBorder);
    translate(-(this.x), -(this.y+offset), -(this.z+offset));
    
    translate(this.x, this.y+offset, this.z-offset);
    box(2*avg*this.r + theBorder, theBorder, theBorder);
    translate(-(this.x), -(this.y+offset), -(this.z-offset));
    
    translate(this.x, this.y-offset, this.z+offset);
    box(2*avg*this.r + theBorder, theBorder, theBorder);
    translate(-(this.x), -(this.y-offset), -(this.z+offset));
    
    translate(this.x, this.y-offset, this.z-offset);
    box(2*avg*this.r + theBorder, theBorder, theBorder);
    translate(-(this.x), -(this.y-offset), -(this.z-offset));
    
    /////////////////////////////////////////////////////////////////////////////////////////
    
    translate(this.x + offset, this.y, this.z+offset);
    box(theBorder, 2*avg*this.r + theBorder, theBorder);
    translate(-(this.x + offset), -(this.y), -(this.z+offset));
    
    translate(this.x - offset, this.y, this.z+offset);
    box(theBorder, 2*avg*this.r + theBorder, theBorder);
    translate(-(this.x - offset), -(this.y), -(this.z+offset));
    
    translate(this.x + offset, this.y, this.z-offset);
    box(theBorder, 2*avg*this.r + theBorder, theBorder);
    translate(-(this.x + offset), -(this.y), -(this.z-offset));
    
    translate(this.x - offset, this.y, this.z-offset);
    box(avg*maxBoxOutline, 2*avg*this.r + theBorder, theBorder);
    translate(-(this.x - offset), -(this.y), -(this.z-offset));
    
    rotateZ(-this.rot);
    //rotateX(-this.rot);
    
    this.z += avg*2 + 1;
    if(this.z >= 800){
      //this.z = -depth - int(random(0, 100));
      this.setPos(int(random(0, width)), int(random(0, height)), -depth - int(random(-2000,2000)));
    }
    noFill();
  }
}

void keyPressed(){
  if(song.isPlaying()){
    song.pause();
  }else{
    song.play();
  }
}
