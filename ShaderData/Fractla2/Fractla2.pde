PShader shader1;
PShape obj;
PImage img;
float ry;
boolean customShader;

public void setup(){
  
  size (600, 360, P3D);
  noStroke();
  img = loadImage("img.jpg");
  //obj = loadShape ("1.obj");
  shader1 = loadShader("fragment.glsl");
  
  shader1.set("resolution", float(width), float(height));  
  
    
}

public void draw () {
  
  shader1.set("time", millis() / 1000.0); 
  shader1.set("mouse", float(mouseX)/500, float(mouseY)/500);
  noStroke();
  shader(shader1); 
  rect(0, 0, width, height);
  
}  

