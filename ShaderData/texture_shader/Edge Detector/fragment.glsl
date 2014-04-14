#define PROCESSING_TEXTURE_SHADER
uniform sampler2D texture;
varying vec4 vertTexCoord;

void main(void) { 
  vec4 neg = texture2D(texture, vertTexCoord.st);
  float a = (neg.x);
  float b = (neg.y);
  float c = (neg.z);
  gl_FragColor = vec4((1.0-a), (1.0-b), (1.0-c), 1.0);
  
}

