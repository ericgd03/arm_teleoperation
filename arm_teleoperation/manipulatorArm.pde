PShape base, shoulder, upArm, loArm, end;
float rotX, rotY;
float posX=1, posY=50, posZ=50;
float alpha, beta, gamma;
float F = 50;
float T = 70;
float millisOld, gTime, gSpeed = 4;
float cord[] = {0, 0, 0};
boolean rotate;

void IK(){
  float X = posX;
  float Y = posY;
  float Z = posZ;

  float L = sqrt(Y*Y+X*X);
  float dia = sqrt(Z*Z+L*L);

  alpha = PI/2-(atan2(L, Z)+acos((T*T-F*F-dia*dia)/(-2*F*dia)));
  beta = -PI+acos((dia*dia-T*T-F*F)/(-2*F*T));
  gamma = atan2(Y, X);
}

void setTime(){
  gTime += ((float)millis()/1000 - millisOld)*(gSpeed/4);
  if(gTime >= 4)  gTime = 0;  
  millisOld = (float)millis()/1000;
}

void writePos(){
  IK();
  setTime();
  posZ = 100*cord[1] - 100;
  posY = -100*(cord[0]) + 100;
  posX = 30*cord[2];
}

float[] Xsphere = new float[99];
float[] Ysphere = new float[99];
float[] Zsphere = new float[99];

void setup(){
    size(1200, 800, OPENGL);
    
    base = loadShape("r5.obj");
    shoulder = loadShape("r1.obj");
    upArm = loadShape("r2.obj");
    loArm = loadShape("r3.obj");
    end = loadShape("r4.obj");
    
    shoulder.disableStyle();
    upArm.disableStyle();
    loArm.disableStyle();
}

void draw(){
   leerCord();
   writePos();
   background(32);
   smooth();
   lights(); 
   directionalLight(51, 102, 126, -1, 0, 0);
    
    for (int i=0; i< Xsphere.length - 1; i++){
    Xsphere[i] = Xsphere[i + 1];
    Ysphere[i] = Ysphere[i + 1];
    Zsphere[i] = Zsphere[i + 1];
    }
    
    Xsphere[Xsphere.length - 1] = posX;
    Ysphere[Ysphere.length - 1] = posY;
    Zsphere[Zsphere.length - 1] = posZ;
   
   noStroke();
   
   translate(width/2, height/2);
   rotateX(rotX);
   rotateY(-rotY);
   scale(-4);
   
   for (int i=0; i < Xsphere.length; i++){
     pushMatrix();
     translate(-Ysphere[i], -Zsphere[i]-11, -Xsphere[i]);
     fill (#D003FF, 25);
     sphere (float(i) / 20);
     popMatrix();
    }
    
   fill(#FFE308);  
   translate(0,-40,0);   
     shape(base);
     
   translate(0, 4, 0);
   rotateY(gamma);
     shape(shoulder);
      
   translate(0, 25, 0);
   rotateY(PI);
   rotateX(alpha);
     shape(upArm);
      
   translate(0, 0, 50);
   rotateY(PI);
   rotateX(beta);
     shape(loArm);
      
   translate(0, 0, -50);
   rotateY(PI);
     shape(end);
}

void leerCord(){
  String[] lines = loadStrings("coordenadas.txt");
  if (lines.length > 0){
    String text = lines[0];
    cord = float(split(text, ','));
    println(cord[0], cord[1], cord[2]);
  }
}

void mouseDragged(){
    rotY -= (mouseX - pmouseX) * 0.01;
    rotX -= (mouseY - pmouseY) * 0.01;
}
