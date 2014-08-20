PShader toon;
boolean shaderEnabled = true;  

void setup() {
  size(640, 360, P3D);
  noStroke();
  fill(204);
  toon = loadShader("fracgment.glsl", "vertex.glsl");
}

void draw() {
  if (shaderEnabled == true) {
    shader(toon);
  }

  noStroke(); 
  background(0); 
  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  directionalLight(204, 204, 204, -dirX, -dirY, -1);
  translate(width/2, height/2);
  sphere(120);
}  

void mousePressed() {
  if (shaderEnabled) {
    shaderEnabled = false;
    resetShader();
  } 
  else {
    shaderEnabled = true;
  }
}

