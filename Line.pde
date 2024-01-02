int nLines = 150;
Line[] lines;

class Line{
  float minZ = -10000, maxZ = 50;
  float x, y, z;
  
  Line(float x, float y) {
    this.x = x;
    this.y = y;
    this.z = random(minZ, maxZ);
  }
  
  void display(float sumLow, float sumMid, float sumHig, float intensity, float sumGlobal) {
    float sizeX = width, sizeY = 10;
    color disColor = color(sumLow*0.67, sumMid*0.67, sumHig*0.67, sumGlobal);
    fill(disColor, ((sumGlobal-5)/1000)*(255+(z/25)));
    noStroke();
    pushMatrix();
    translate(x, y, z);
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    box(1);
    popMatrix();
    
    
    disColor = color(sumLow*0.5, sumMid*0.5, sumHig*0.5, sumGlobal);
    fill(disColor, (sumGlobal/5000)*(255+(z/25)));
    pushMatrix();
    translate(x, y, z);
    scale(sizeX, sizeY, 10);
    box(1);
    popMatrix();
    
    z += (sumGlobal/150) * (sumGlobal/150);
    if (z >= maxZ) {
      z = minZ;  
    }
  }
}
