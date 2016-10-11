#ifdef GL_ES
precision mediump float;
#endif

varying vec3 vVertexColor;
varying vec3 vLighting;
  
void main() {
    gl_FragColor = vec4(vLighting * vVertexColor, 1.0);
}
