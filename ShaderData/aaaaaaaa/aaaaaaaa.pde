 * Press the mouse to switch between the custom and default shader.
 */

PShader blur;

void setup() {
  size(640, 360, P2D);
  blur = loadShader("fragment.glsl"); 
  stroke(255, 0, 0);
  rectMode(CENTER);
}

void draw() {
  filter(blur);  
  rect(mouseX, mouseY, 150, 150); 
  ellipse(mouseX, mouseY, 100, 100);
}


