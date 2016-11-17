#version 120
varying vec4 texcoord;

uniform sampler2D gcolor;
uniform sampler2D depthtex1;

uniform sampler2D composite;

uniform float near;
uniform float far;

vec4 _NFOD; //x: near clip, y: far clip, z: overlap, w: depth curve
vec4 _SFCO; //x: slice count, y: flip x, z: calibration mode, w: should be slice order
//vec3 _SO[3];
 vec4 _SO[10];
 vec4 _TD[10];
 vec4 _SK[10];


float LinearizeDepth(float z)
{
  float n = near; // camera z near
  float f = 10.0; // camera z far
  return (2.0 * n) / (f + n - z * (f - n));
}

void main(){
_SO[0] = vec4(0.9, 1.0, 0.0, 0.0);
_SO[1] = vec4(0.9, 1.0, 0.0, 0.0);
_SO[2] = vec4(0.9, 1.0, 0.0, 0.0);
_SO[3] = vec4(0.9, 1.0, 0.0, 0.0);
_SO[4] = vec4(0.9, 1.0, 0.0, 0.0);
_SO[5] = vec4(0.9, 1.0, 0.0, 0.0);
_SO[6] = vec4(0.9, 1.0, 0.0, 0.0);
_SO[7] = vec4(0.9, 1.0, 0.0, 0.0);
_SO[8] = vec4(0.9, 1.0, 0.0, 0.0);
_SO[9] = vec4(0.9, 1.0, 0.0, 0.0);

_TD[0] = vec4(0,0,0,0);
_TD[1] = vec4(0,0,0,0);
_TD[2] = vec4(0,0,0,0);
_TD[3] = vec4(0,0,0,0);
_TD[4] = vec4(0,0,0,0);
_TD[5] = vec4(0,0,0,0);
_TD[6] = vec4(0,0,0,0);
_TD[7] = vec4(0,0,0,0);
_TD[8] = vec4(0,0,0,0);
_TD[9] = vec4(0,0,0,0);

_SK[0] = vec4(0,0,0,0);
_SK[1] = vec4(0,0,0,0);
_SK[2] = vec4(0,0,0,0);
_SK[3] = vec4(0,0,0,0);
_SK[4] = vec4(0,0,0,0);
_SK[5] = vec4(0,0,0,0);
_SK[6] = vec4(0,0,0,0);
_SK[7] = vec4(0,0,0,0);
_SK[8] = vec4(0,0,0,0);
_SK[9] = vec4(0,0,0,0);

  _NFOD= vec4(near,1.0,0.5,0.0);

  _SFCO= vec4(10.0,0.0,0.0,0.0);

float fs = floor(texcoord.y * _SFCO.x);


vec4 SO = vec4(0,0,0,0);
vec4 TD = vec4(0,0,0,0);
vec4 SK = vec4(0,0,0,0);

for (float i = 0.0; i < 10.0; i+=1.0) {
  SO += _SO[int(i)] * step(i, fs) * (1.0 - step(i + 1.0, fs));
  TD += _TD[int(i)] * step(i, fs) * (1.0 - step(i + 1.0, fs));
  SK += _SK[int(i)] * step(i, fs) * (1.0 - step(i + 1.0, fs));
}


/*
float4 SO = float4(0, 0, 0, 0); //x: size x, y: size y, z: offset x, w: offset y
float4 TD = float4(0, 0, 0, 0); //x: sin(), y: cos(), z: distort x, w: distort y
float4 SK = float4(0, 0, 0, 0); //x: tan(x skew), y: tan(y skew), z: 0, w: 0
for (int i = 0; i < 10; i++) {
  SO += _SO[i] * step(i, fs) * (1 - step(i + 1, fs));
  TD += _TD[i] * step(i, fs) * (1 - step(i + 1, fs));
  SK += _SK[i] * step(i, fs) * (1 - step(i + 1, fs));
}
*/


float g = floor(texcoord.y * _SFCO.x) / _SFCO.x + 1.0 / (_SFCO.x * 2.0);
g = (1.0 - g) * _SFCO.w + g * (1.0 - _SFCO.w);

vec4 foldedTexCoord=texcoord;
foldedTexCoord.y = fract((texcoord.y +SO.w) *_SFCO.x);




  				/*** size, offset etc. below. ***/

					//first offset to center, will restore position later
					vec2 nuv = vec2(foldedTexCoord.x - 0.5, foldedTexCoord.y - 0.5);

					//pinch x
					TD.z = sign(TD.z) * (1.0 - abs(TD.z)) + float(TD.z == 0.0); //this makes the math more humanlike.
           float clampedZ =clamp(TD.z,0.0,1.0);
					float px = foldedTexCoord.x * sign(clampedZ) + (1.0 - foldedTexCoord.x) * step(TD.z, 0.0); //so depending on the sign of distortion it does one side or other
					TD.z = abs(TD.z) * (px); //this will be "lerped"
					nuv.y = nuv.y * (1.0 / (TD.z + (1.0 - px))); //perform a center-based scale on the y

					//pinch y
					TD.w = sign(TD.w) * (1.0 - abs(TD.w)) + float(TD.w == 0.0); //this makes the math more humanlike.

          float clampedW =clamp(TD.w,0.0,1.0);
					float py = foldedTexCoord.y * sign(clampedW) + (1.0 - foldedTexCoord.y) * step(TD.w, 0.0); //so depending on the sign of distortion it does the top or bottom
					TD.w = abs(TD.w) * (py); //this will be "lerped"
					nuv.x = nuv.x * (1.0 / (TD.w + (1.0 - py))); //perform a center-based scale on the x

					//skew x y
					mat3 mySkew = mat3(
						1, SK.y, 0,
						SK.x, 1, 0,
						0, 0, 1
						);
					//nuv = mySkew*nuv;

					//rotation
					mat2 myRotator = mat2(
						TD.y, -TD.x,
						TD.x, TD.y
						);

					nuv = myRotator* nuv;

					//size x y
					nuv.x = nuv.x / SO.x;
					nuv.y = nuv.y / SO.y;

					//offset x y
					nuv.x = nuv.x + SO.z;
					nuv.y = nuv.y + SO.w;

					//set IN.uv to a nuv returned to center
					foldedTexCoord.x=nuv.x + 0.5;
          foldedTexCoord.y=nuv.y + 0.5;

					//darken extraneous pixels

					float nuvd = float(foldedTexCoord.x >= 0.0) * float(foldedTexCoord.x <= 1.0) * float(foldedTexCoord.y >= 0.0) * float(foldedTexCoord.y <= 1.0);

					vec4 nuvdc = vec4(nuvd, nuvd, nuvd, 1);

					/*** end size, offset section ***/

//color and depth curve apply
vec4 c = texture2D(gcolor, foldedTexCoord.xy);
float d = texture2D(depthtex1, foldedTexCoord.xy).x;
float ld = -(sign(_NFOD.x)-1.0) * d + sign(_NFOD.x) * LinearizeDepth(d);
d= mix(ld, d, _NFOD.w);

//calibration adjustments

_NFOD.z += _SFCO.z * 100.0; //ramp up the overlap if calibration is on
float so = fs * (1.0 - _SFCO.w) + (_SFCO.x - fs - 1.0) * _SFCO.w; //if the slice order is flipped, flip the fs (current slice), call it "so", and use it in the next line;
float cb = 1.0 - _SFCO.z * step(foldedTexCoord.x, 0.9) * step(0.1, foldedTexCoord.x) * step(foldedTexCoord.y, 0.2) * step(0.1, foldedTexCoord.y) * step(1.0, so); //calibration black box so font doesn't repeat forever


//n calc`
float val = 1.0 - abs(g - d) * (_SFCO.x - _NFOD.z * _SFCO.x / 2.0);
float clamped =clamp(val,0.0,1.0);
float n = pow(clamped, 0.5);

//f calc
float f1= clamp((-2.0 * _SFCO.x * d + 2.0 * _SFCO.x),0.0,1.0);
float f2= clamp((4.0 * _SFCO.x * d + 0.7),0.0,1.0);
float f = f1*f2;


//vec4 r= c*n*f;
vec4 r = c * n * f * cb * nuvdc;

gl_FragColor = r*2.0;

//gl_FragColor = texture2D(composite,texcoord.st);

//gl_FragColor=texture2D(gaux1,texcoord.xy);

}
