int iWidth = 200, iHeight = 200; 

void imageProcessing(){
  tmp = createImage(iWidth, iHeight, RGB);  
   
  //image1: カラー画像をセピア調画像に変換
  int   x, y;                                
  float R, G, B;                            
  float newR, newG, newB;                    
  color c;                                  
 
  for (y = 0; y < iHeight; y++) {            
    for (x = 0; x < iWidth; x++) {          
      c = image1.get(x, y);                
      R = red(c);                           
      G = green(c);
      B = blue(c);                          
      
      newR = .393*R + .769*G + .189*B;      
      newG = .349*R + .686*G + .168*B;       
      newB = .272*R + .534*G + .131*B;       
      c = color(newR, newG, newB);          
      image1.set(x, y, c);                   
    }
  }
  
  //image2: カラー画像のホワイトバランス調整
  int[] histR = new int[256];                         
  int[] histG = new int[256];                       
  int[] histB = new int[256];                        
  int   minR, minG, minB, maxR, maxG, maxB;          
  float a, s;                                      
  float[] tableR = new float[256];                 
  float[] tableG = new float[256];                 
  float[] tableB = new float[256];               
  
  // ヒストグラムを計算する
  for (y = 0; y < iHeight; y++) {                  
    for (x = 0; x < iWidth; x++) {                 
      c = image2.get(x, y);                        
      histR[int(red(c))  ]++;                      
      histG[int(green(c))]++;                      
      histB[int(blue(c)) ]++;                      
    }
  }
 
  // 累積ヒストグラムを計算する
  for (int i = 1; i < 256; i++) {                  
    histR[i] += histR[i-1];                        
    histG[i] += histG[i-1];                        
    histB[i] += histB[i-1];                        
  }
 
  a = .02;                                       
  s = histR[255];                                
  minR = minG = minB = 0;                        
  maxR = maxG = maxB = 255;                          
  while (histR[minR]/s < a && minR < 255) minR++;    
  while (histG[minG]/s < a && minG < 255) minG++;    
  while (histB[minB]/s < a && minB < 255) minB++;    
  a = 1 - a;                                         
  while (histR[maxR]/s > a && maxR > 0) maxR--;      
  while (histG[maxG]/s > a && maxG > 0) maxG--;      
  while (histB[maxB]/s > a && maxB > 0) maxB--;      
  
  for (int i = 0; i < 256; i++) {                    
    tableR[i] = 255./(maxR-minR)*(i-minR);           
    tableG[i] = 255./(maxG-minG)*(i-minG);           
    tableB[i] = 255./(maxB-minB)*(i-minB);           
  }
 
  for (y = 0; y < iHeight; y++) {                 
    for (x = 0; x < iWidth; x++) {                
      c = image2.get(x, y);                       
      R = tableR[int(red(c))];                    
      G = tableG[int(green(c))];                  
      B = tableB[int(blue(c))];                   
      tmp.set(x, y, color(R, G, B));              
    }
  }
  for (y = 0; y < iHeight; y++) {
    for (x = 0; x < iWidth; x++) {
      c = tmp.get(x, y);
      image2.set(x, y, c);
    }
  }
  image(image2,0,0);
  
  //image3: 円の大きさと色で画像を再構成する、彩度がサイズに対応
  for (y = 0; y < iHeight; y++) {
    for (x = 0; x < iWidth; x++) {
      c = color(255, 255, 255);
      tmp.set(x, y, c);
    }
  }
  for (int i = 0; i < 4000; i++) {
    x = int(random(iWidth));
    y = int(random(iHeight));
    c = image3.get(x, y);
    fill(c, 127);
    float ellipseSize = map(saturation(c), 0, 255, 1, 5);
    for (int u=max((int)(x-ellipseSize),0); u<=min(x+ellipseSize,iWidth); u++){
      for (int v=max((int)(y-ellipseSize),0); v<=min(y+ellipseSize,iHeight); v++) {
        if ((u-x)*(u-x)+(v-y)*(v-y)<=ellipseSize*ellipseSize) tmp.set(u, v, c);
      }
    }
  }
  for (y = 0; y < iHeight; y++) {
    for (x = 0; x < iWidth; x++) {
      c = tmp.get(x, y);
      image3.set(x, y, c);
    }
  }
  
  //image4:エンボス加工
  float d;                                       
  image4.filter(GRAY);                           
  for (y = 0; y < iHeight-1; y++) {              
    for (x = 0; x < iWidth-1; x++) {             
      d = red(image4.get(x+1,y+1)) - red(image4.get(x,y)); 
      d += 128;                                 
      tmp.set(x, y, color(d));                  
    }
  }
  for (y = 0; y < iHeight; y++) {
    for (x = 0; x < iWidth; x++) {
      c = tmp.get(x, y);
      image4.set(x, y, c);
    }
  }
  
  //image5: 1次微分フィルタ
  float dx, dy, norm;                             
  image5.filter(GRAY);                            
  
  for (y = 1; y < iHeight-1; y++) {               
    for (x = 1; x < iWidth-1; x++) {              
      dx = red(image5.get(x+1,y  )) - red(image5.get(x,y)); 
      dy = red(image5.get(x  ,y+1)) - red(image5.get(x,y)); 
      norm = sqrt(dx*dx + dy*dy);                  
 
      dx = abs(dx);                      
      dy = abs(dy);                      
 
      tmp.set(x, y, color(norm));                 
    }
  }
  for (y = 0; y < iHeight; y++) {
    for (x = 0; x < iWidth; x++) {
      c = tmp.get(x, y);
      c = color(255.0-red(c), 255.0-green(c), 255.0-blue(c));
      image5.set(x, y, c);
    }
  }
  
  //image6: 2次微分フィルタ（ラプラシアンフィルタ）
  image6.filter(GRAY);                     
  for (y = 1; y < iHeight-1; y++) {        
    for (x = 1; x < iWidth-1; x++) {       
      
      d =                          +   red(image6.get(x,y-1)) 
          + red(image6.get(x-1,y)) - 4*red(image6.get(x,y  )) + red(image6.get(x+1,y  ))
                                   +   red(image6.get(x,y+1));
 
      d = abs(d);                      
      tmp.set(x, y, color(d));         
    }
  }
  for (y = 0; y < iHeight; y++) {
    for (x = 0; x < iWidth; x++) {
      c = tmp.get(x, y);
      c = color(255.0-red(c), 255.0-green(c), 255.0-blue(c));
      image6.set(x, y, c);
    }
  }
  image(image6,0,0);
}
