#define PROCESSING_TEXTURE_SHADER
 
uniform mat4 transform;
uniform mat4 texMatrix;
 
attribute vec4 vertex;
attribute vec2 texCoord;
 
varying vec4 vertTexCoord;
 
void main() {
  gl_Position = transform * vertex;
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}