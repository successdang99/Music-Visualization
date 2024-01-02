float minZ = -10000, maxZ = 1000;

int nShapes;
Shape[] shapes;

class Shape {
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  int type;
  int select;
  
  Shape(){
    //random position
    x = random(0, width);
    y = random(0, height);
    z = random(minZ, maxZ);
    type = (int)random(0, 2);
    select = (int)random(0, 25);
    //random rotation
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
    sumRotX = 0;
    sumRotY = 0;
    sumRotZ = 0;
  }
  
  void display(float sumLow, float sumMid, float sumHig, float intensity, float sumGlobal){
    color disColor = color(sumLow*0.67, sumMid*0.67, sumHig*0.67, intensity*5);
    fill(disColor, 255);
    stroke(color(255, 150-(20*intensity)));
    strokeWeight(1 + (sumGlobal/300));
    
    pushMatrix();
    translate(x, y, z);
     
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    if (this.type == 0) {
      if (this.select<2) {
        scale(intensity);
        beginShape(QUADS);
          texture(image3);
          vertex(-1,-1, 1, 0, 0); 
          vertex(-1, 1, 1, 0, 1); 
          vertex( 1, 1, 1, 1, 1); 
          vertex( 1,-1, 1, 1, 0);
        endShape();
  
        beginShape(QUADS);  
          texture(image3);
          vertex(-1,-1,-1, 0, 0); 
          vertex(-1, 1,-1, 0, 1); 
          vertex( 1, 1,-1, 1, 1); 
          vertex( 1,-1,-1, 1, 0);
        endShape();
  
        beginShape(QUADS);  
          texture(image1);
          vertex(-1,-1, 1, 0, 1); 
          vertex( 1,-1, 1, 1, 1); 
          vertex( 1,-1,-1, 1, 0); 
          vertex(-1,-1,-1, 0, 0);
        endShape();
  
        beginShape(QUADS);
          texture(image1);
          vertex(-1, 1, 1, 0, 0); 
          vertex( 1, 1, 1, 1, 0); 
          vertex( 1, 1,-1, 1, 1); 
          vertex(-1, 1,-1, 0, 1);
        endShape();
  
        beginShape(QUADS); 
          texture(image2);
          vertex(-1,-1, 1, 0, 0); 
          vertex(-1, 1, 1, 0, 1);
          vertex(-1, 1,-1, 1, 1); 
          vertex(-1,-1,-1, 1, 0);
        endShape();
 
        beginShape(QUADS); 
          texture(image2);
          vertex(1,-1, 1, 0, 0);
          vertex(1, 1, 1, 0, 1);
          vertex(1, 1,-1, 1, 1);
          vertex(1,-1,-1, 1, 0);
        endShape();  
      } else {
        box(100+(intensity/2));
      }
    } else {
      if (this.select==4){
        globe = createShape(SPHERE, 100+intensity); 
        globe.setStroke(false);
        globe.setTexture(image4);
        shape(globe);
      } else if (this.select==5){
        globe = createShape(SPHERE, 100+intensity); 
        globe.setStroke(false);
        globe.setTexture(image5);
        shape(globe);
      } else if (this.select==6){
        globe = createShape(SPHERE, 100+intensity); 
        globe.setStroke(false);
        globe.setTexture(image6);
        shape(globe);
      } else {
        sphere(50+(intensity/2));
      }
    }
    popMatrix();
    z += 1+(intensity/5)+(sumGlobal/150)*(sumGlobal/150);
   
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = minZ;
    } 
  }
}
