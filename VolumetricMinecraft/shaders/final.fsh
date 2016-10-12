#version 120
varying vec4 texcoord;

uniform sampler2D gcolor;
uniform sampler2D depthtex1;

uniform float near;
uniform float far;

vec4 _NFOD; //x: near clip, y: far clip, z: overlap, w: depth curve
vec4 _SFCO; //x: slice count, y: flip x, z: calibration mode, w: should be slice order

float LinearizeDepth(float z)
{
  float n = near; // camera z near
  float f = 10.0; // camera z far
  return (2.0 * n) / (f + n - z * (f - n));
}

void main(){

  _NFOD= vec4(near,1.0,0.5,0.0);

  _SFCO= vec4(10.0,0.0,0.0,0.0);

float fs = floor(texcoord.y * _SFCO.x);

float g = floor(texcoord.y * _SFCO.x) / _SFCO.x + 1.0 / (_SFCO.x * 2.0);

g = (1.0 - g) * _SFCO.w + g * (1.0 - _SFCO.w);

vec4 foldedTexCoord=texcoord;
foldedTexCoord.y = fract(texcoord.y*_SFCO.x);

vec4 c = texture2D(gcolor, foldedTexCoord.xy);


float d = texture2D(depthtex1, foldedTexCoord.xy).x;


float ld = -(sign(_NFOD.x)-1.0) * d + sign(_NFOD.x) * LinearizeDepth(d);
d= mix(ld, d, _NFOD.w);


//_NFOD.z += _SFCO.z * 100; //ramp up the overlap if calibration is on


float val = 1.0 - abs(g - d) * (_SFCO.x - _NFOD.z * _SFCO.x / 2.0);

float clamped =clamp(val,0.0,1.0);
float n = pow(clamped, 0.5);

float f1= clamp((-2.0 * _SFCO.x * d + 2.0 * _SFCO.x),0.0,1.0);
float f2= clamp((4.0 * _SFCO.x * d + 0.7),0.0,1.0);
float f = f1*f2;


vec4 r= c*n*f;

gl_FragColor = r*2.0;
}
