PShader shader;

void setup() {
  size(640, 360, P2D);
  noStroke();
  shader = loadShader("mario.glsl");
  shader.set("resolution", float(width), float(height));   
}

void draw() {
  background(0);
    
  shader.set("time", (float)(millis()/1000.0));
  shader(shader); 
  rect(0, 0, width, height);

  surface.setTitle("frame: " + frameCount + " - fps: " + frameRate);     
}


