PShader neg;
PImage img;
void setup() {
  size(800, 600, P2D);
  img = loadImage("img.jpg");
  neg = loadShader("fragment.glsl");
  
}


void draw() {

  shader(neg);
  
  image(img, 0, 0);
}

