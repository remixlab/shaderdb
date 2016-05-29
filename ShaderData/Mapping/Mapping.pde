PImage diffuseMap;
PImage normalMap;
 
PShape plane;
PShape can;
 
PShader normalMapShader;
 
void setup() {
  size(256, 256, P3D);
   
  diffuseMap = loadImage("colorrock.png");
  normalMap = loadImage("normalrock.png");
  
  //can = createSphere(350, 64, diffuseMap); 
  plane = createPlane(diffuseMap);
   
  normalMapShader = loadShader("frag.glsl", "vert.glsl");
  shader(normalMapShader);
  normalMapShader.set("normalMap", normalMap);
}
 
void draw(){
  background(0);
  translate(width/2, height/2, 0);
  shader(normalMapShader);
  scale(128);
  shape(plane);
  
}
 
void mouseMoved(){
  updateCursorCoords();
}
 
void mouseDragged(){
  updateCursorCoords();
}
 
void updateCursorCoords(){
  normalMapShader.set("mouseX", (float)mouseX);
  normalMapShader.set("mouseY", height - (float)mouseY);
}
 
void mousePressed(){
  normalMapShader.set("useSpecular", 1);
}
 
void mouseReleased(){
  normalMapShader.set("useSpecular", 0);
}
 
PShape createPlane(PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD);
  sh.noStroke();
  sh.texture(tex);
  sh.vertex( 1, -1, 0, 1, 0);
  sh.vertex( 1,  1, 0, 1, 1);   
  sh.vertex(-1,  1, 0, 0, 1);
  sh.vertex(-1, -1, 0, 0, 0);
  sh.endShape();
  return sh;
}

PShape createSphere(float r, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.noStroke();
  sh.texture(tex);
  final float dA = TWO_PI / detail; // change in angle
 
  // process the sphere one band at a time
  // going from almost south pole to almost north
  // poles must be handled separately
  float theta2 = -PI/2+dA;
  float SHIFT = PI/2;
  float z2 = sin(theta2); // height off equator
  float rxyUpper = cos(theta2); // closer to equator
  for (int i = 1; i < detail; i++) {
    float theta1 = theta2; 
    theta2 = theta1 + dA;
    float z1 = z2;
    z2 = sin(theta2);
    float rxyLower = rxyUpper;
    rxyUpper = cos(theta2); // radius in xy plane
    sh.beginShape(QUAD_STRIP);
    for (int j = 0; j <= detail; j++) {
      float phi = j * dA; //longitude in radians
      float xLower = rxyLower * cos(phi);
      float yLower = rxyLower * sin(phi);
      float xUpper = rxyUpper * cos(phi);
      float yUpper = rxyUpper * sin(phi);
      float u = phi/TWO_PI;
      sh.normal(xUpper, yUpper, z2);
      sh.vertex(r*xUpper, r*yUpper, r*z2, u,(theta2+SHIFT)/PI);    
      sh.normal(xLower, yLower, z1);
      sh.vertex(r*xLower, r*yLower, r*z1, u,(theta1+SHIFT)/PI);
    }
    sh.endShape();   
  }
  return sh;
}

