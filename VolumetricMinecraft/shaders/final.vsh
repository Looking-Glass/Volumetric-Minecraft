#version 120

varying vec4 texcoord;

void main(){
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

  texcoord=gl_MultiTexCoord0;
  //texcoord.x=1-texcoord.x;

//do want this for flip y
  texcoord.y=1-texcoord.y;

}
