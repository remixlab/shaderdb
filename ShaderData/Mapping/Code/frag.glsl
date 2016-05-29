#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
#define PI 3.141592658
 
uniform sampler2D normalMap;
uniform sampler2D texture;
 
uniform int useSpecular;
 
uniform float mouseX;
uniform float mouseY;
 
varying vec4 vertTexCoord;
 
const vec3 view = vec3(0,0,1);
const float shine = 40.0;
 
void main() {
  
//  vec3 normalVector = normalize(texture2D(normalMap, vertTexCoord.st).rgb * 2.0 - 1.0)
 // vec4 normalColor = normalize(texture2D(normalMap, vertTexCoord.st).rgb
//  vec3 normalVector = vec3(normalColor - vec4(1.0));


  // Convert the RGB values to XYZ
  vec4 normalColor  = texture2D(normalMap, vertTexCoord.st);
  vec3 normalVector = vec3(normalColor - vec4(1.0));
  //normalVector = normalize(normalVector); OJO
 
  vec3 rayOfLight = normalize(vec3(gl_FragCoord.x  - mouseX, gl_FragCoord.y - mouseY, -150.0));
  //rayOfLight = normalize(rayOfLight);
 
  float nDotL = dot(rayOfLight, normalVector);
  //float nDotL = max(dot(rayOfLight, normalVector),0.0);
  

  vec3 finalSpec = vec3(0);
 
  if(useSpecular == 1){
    vec3 reflection = normalVector;
    reflection = reflection * nDotL * 2.0;
    reflection -= rayOfLight;
    float specIntensity = pow( dot(reflection, view), shine);
    finalSpec = vec3(1.0, 0.5, 0.2) * specIntensity;
  }
 
    float finalDiffuse = acos(nDotL)/PI;
 
    //float finalDiffuse = max(nDotL, 0.0);
  gl_FragColor = vec4(finalSpec + vec3(texture2D(texture, vertTexCoord.st) * finalDiffuse), 1.0);

  //gl_FragColor = vec4(vec3(texture2D(texture, vertTexCoord.st)*finalDiffuse), 1.0);
 //gl_FragColor = vec4(colorMap, vertTexCoord.st,1.0);
}