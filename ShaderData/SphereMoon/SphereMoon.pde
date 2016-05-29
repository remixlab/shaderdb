PImage diffuseMap;
PImage normalMap;

PShape can;
float angle;
PShape moon; 
float zoom = 250; // scale factor aka zoom 
PShader normalMapShader;
 
 
void setup() {
  size(400, 400, P3D);  
  
  diffuseMap = loadImage("cmap.jpg");
  normalMap = loadImage("cnormal.jpg");
  moon = createIcosahedron(6); 
  
  
  can = createSphere(150, 74, diffuseMap);
  normalMapShader = loadShader("frag.glsl", "vert.glsl");
  shader(normalMapShader);
  normalMapShader.set("normalMap", normalMap);
}
 
 
void draw() {    
  background(0);
  //shader(normalMapShader);      
  translate(width/2, height/2);
  rotateX(-PI/2);
  rotateZ(angle);  
  
      // zoom out/in with the -/+ keys
  if (keyPressed) {
    if (key == 'a') { zoom -= 3; }
    if (key == 'z' || key == '=') { zoom += 3; }
  }
  scale(zoom); // set the scale/zoom level
  
  
  shape(moon);
  //shape(can);  
  angle += 0.01;

}
 
 
PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
}
 
 
PShape createSphere(float r, int detail, PImage tex) {
  textureMode(IMAGE);
  PShape sh = createShape();
//
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
   sh.beginShape(TRIANGLES);
   sh.noStroke();
   sh.texture(tex);
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

 

