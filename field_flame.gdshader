shader_type canvas_item;


uniform vec4 colour: source_color = vec4(1.);
uniform vec2 flow_movement = vec2(0., 0.);
uniform vec2 distortion_movement = vec2(0., 0.);
uniform float normal_strength = 40.;
uniform float distortion_strength = .1;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap, repeat_disable;


/** NOISE **/
float rand(vec2 co) {
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 hash( vec2 p ) {
	p = vec2( dot(p,vec2(127.1,311.7)),
			  dot(p,vec2(269.5,183.3)) );

	return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise( in vec2 p ) {
   float K1 = 0.366025404; // (sqrt(3)-1)/2;
   float K2 = 0.211324865; // (3-sqrt(3))/6;

	vec2 i = floor( p + (p.x+p.y)*K1 );
	
    vec2 a = p - i + (i.x+i.y)*K2;
    vec2 o = step(a.yx,a.xy);    
    vec2 b = a - o + K2;
	vec2 c = a - 1.0 + 2.0*K2;

    vec3 h = max( 0.5-vec3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );

	vec3 n = h*h*h*h*vec3( dot(a,hash(i+0.0)), dot(b,hash(i+o)), dot(c,hash(i+1.0)));

    return dot( n, vec3(70.0) );
}

float fbm ( in vec2 p ) {
    float f = 0.0;
    mat2 m = mat2(vec2(1.6,  1.2), vec2(-1.2,  1.6 ));
    f  = 0.5000 * noise(p); p = m*p;
    f += 0.2500 * noise(p); p = m*p;
    f += 0.1250 * noise(p); p = m*p;
    f += 0.0625 * noise(p); p = m*p;
    f = 0.5 + 0.5 * f;
    return f;
}

/** DISTORTION **/
vec3 bumpMap(vec2 uv) { 
	vec2 iResolution = vec2(640., 360.);
	vec2 s = 1. / iResolution.xy;
	float p =  fbm(uv);
	float h1 = fbm(uv + s * vec2(1., 0));
	float v1 = fbm(uv + s * vec2(0, 1.));
	   
	vec2 xy = (p - vec2(h1, v1)) * normal_strength;
    return vec3(xy + .5, 1.);
}

/** MAIN **/
void fragment() {
	float timeScale = TIME * .475;
	//vec2 iResolution = vec2(640., 360.);
    vec2 uv = UV;

    vec3 normal = bumpMap(uv * vec2(1.0, 0.3) - distortion_movement * timeScale);
    
    vec2 displacement = clamp((normal.xy - .5) * distortion_strength, -1., 1.);
    uv += displacement; 
    
    vec2 uvT = (uv * vec2(1.0, 0.5)) + timeScale * flow_movement;
    float n = pow(fbm(8.0 * uvT), 1.0);    
    
    float gradient = pow(1.0 - uv.y, 2.0) * 5.;
    float finalNoise = n * gradient;
    
    vec3 color = finalNoise * vec3(2. * n, 2. * n * n * n, n * n * n * n);
	vec4 _texture = texture(TEXTURE, uv);
    COLOR = mix(vec4(color, 1.), _texture, 1.) * colour;
}















	