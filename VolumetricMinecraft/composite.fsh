#version 120

uniform sampler2D gcolor;
uniform sampler2D gaux1;

varying vec4 texcoord;


void main(){

  	gl_FragData[0] = texture2D(gcolor, texcoord.st);

    gl_FragData[3] = texture2D(gaux1, texcoord.st);
    //gl_FragData[3]=vec4(1,1,0,1);
}
