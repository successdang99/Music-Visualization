import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;       // Minimのインスタンス
AudioPlayer music; // オーディオプレイヤー
FFT fft;           // FFT解析のインスタンス
PImage image1, image2, image3, image4, image5, image6, tmp;
PShape globe;

float[] rot;       //角度を保存
float[] rotSpeed;  //角速度

//spectrum
float low = 0.03;
float mid = 0.125;
float hig = 0.20;
float sumLow = 0, oldSumLow = 0;
float sumMid = 0, oldSumMid = 0;
float sumHig = 0, oldSumHig = 0;
float sumDecrease = 25; 

void setup(){
  fullScreen(P3D);
  blendMode(ADD);
  frameRate(60);
  minim = new Minim(this);
  music = minim.loadFile("music.mp3");
  
  //Create the FFT object to analyze the music
  fft = new FFT(music.bufferSize(), music.sampleRate());
  
  //One cube or one sphere per frequency band
  nShapes = (int)(fft.specSize() * 0.15);
  shapes = new Shape[nShapes];
  for (int i=0; i<nShapes; i++){
    shapes[i] = new Shape();
  }
  
  //line to make the roa
  lines = new Line[nLines];
  for (int i=0; i<nLines; i++){
    lines[i] = new Line(width/2, height);
  }
  
  rot = new float[(int)(fft.specSize())];
  rotSpeed = new float[(int)(fft.specSize())];
  for (int i = 0; i < fft.specSize(); i++) {
    rot[i] = 0;
    rotSpeed[i] = 0;
  }
  background(0);
  music.play(0);
  image1 = loadImage("cat1.jpg");
  image2 = loadImage("cat2.jpg");
  image3 = loadImage("cat3.jpg");
  image4 = loadImage("cat4.jpg");
  image5 = loadImage("cat5.jpg");
  image6 = loadImage("cat6.jpg");
  imageProcessing();
  textureMode(NORMAL);
}

//draw for each frame of the music
void draw(){
 //fade
  blendMode(BLEND);
  noStroke();
  fill(0, 0, 0, 5);
  rect(0, 0, width, height);
  
  blendMode(ADD); 
  fft.forward(music.mix);
  
  oldSumLow = sumLow;
  oldSumMid = sumMid;
  oldSumHig = sumHig;
  sumLow = 0;
  sumMid = 0;
  sumHig = 0;
  
  for(int i = 0; i < fft.specSize()*low; i++) {
    sumLow += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*low); i < fft.specSize()*mid; i++) {
    sumMid += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*mid); i < fft.specSize()*hig; i++) {
    sumHig += fft.getBand(i);
  }
  
  //Slow down
  if (oldSumLow > sumLow) {
    sumLow = oldSumLow - sumDecrease;
  }
  
  if (oldSumMid > sumMid) {
    sumMid = oldSumMid - sumDecrease;
  }
  
  if (oldSumHig > sumHig) {
    sumHig = oldSumHig - sumDecrease;
  }
  
  background(sumLow/100, sumMid/100, sumHig/100);
  
  float sumGlobal = 0.66*sumLow + 0.8*sumMid + sumHig;
  for(int i = 0; i < nShapes; i++) {
    float band = fft.getBand(i);
    shapes[i].display(sumLow, sumMid, sumHig, band, sumGlobal);
  }
  
  float preBand = fft.getBand(0);
  float dist = -25;
  float Mult = 2;
  
  for(int i = 1; i < fft.specSize(); i++) {
    float band = fft.getBand(i)*(1 + (i/50)); 
    stroke(100+sumLow, 100+sumMid, 100+sumHig, 255-i);
    strokeWeight(1 + (sumGlobal/100));
   
    //left
    line(0, height-(preBand*Mult), dist*(i-1), 0, height-(band*Mult), dist*i);
    line((preBand*Mult), height, dist*(i-1), (band*Mult), height, dist*i);
    line(0, height-(preBand*Mult), dist*(i-1), (band*Mult), height, dist*i);
    
    //right
    line(width, height-(preBand*Mult), dist*(i-1), width, height-(band*Mult), dist*i);
    line(width-(preBand*Mult), height, dist*(i-1), width-(band*Mult), height, dist*i);
    line(width, height-(preBand*Mult), dist*(i-1), width-(band*Mult), height, dist*i);
   
    preBand = band;
  }
  
  //The road
  for(int i = 0; i < nLines; i++) {
    float intensity = fft.getBand(i%((int)(fft.specSize()*hig)));
    lines[i].display(sumLow, sumMid, sumHig, intensity, sumGlobal);
  }
  
  //The star
  translate(width/8, height/8);
  for (int i = 0; i < fft.specSize(); i++) {
    float x = map(i, 0, fft.specSize(), 0, width);
    float r = map(fft.getBand(i), 0, 1.0, 0, 0.2);
    float size = map(fft.getBand(i), 0, 1.0, 0.1, 0.5);

    rotSpeed[i] = r;
    rot[i] += rotSpeed[i];
   
    pushMatrix();
    rotate(radians(rot[i]));
    fill(sumLow*0.67, sumMid*0.67, sumHig*0.67, sumGlobal);
    ellipse(x, 0, size, size);
    popMatrix();
  }
  
  translate(width*3/4, 0);
  for (int i = 0; i < fft.specSize(); i++) {
    float h = map(i, 0, fft.specSize(), 0, 255);
    float x = map(i, 0, fft.specSize(), 0, width);
    float r = map(fft.getBand(i), 0, 1.0, 0, 0.2);
    float size = map(fft.getBand(i), 0, 1.0, 0.1, 0.5);

    rotSpeed[i] = r;
    rot[i] += rotSpeed[i];
   
    pushMatrix();
    rotate(radians(rot[i]));
    fill(sumLow*0.67, sumMid*0.67, sumHig*0.67, sumGlobal);
    ellipse(x, 0, size, size);
    popMatrix();
  }
}

void keyPressed() {
  if(key == 'p' || key == 'P') {
    music.pause();
  }
  else if(key == 'q' || key == 'Q') {
    music.play();
  }
}
