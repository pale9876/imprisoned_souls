shader_type canvas_item;

uniform sampler2D t;
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.05; 

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    //vec2 uv = SCREEN_UV;
    vec4 color = texture(t, UV);

    float noise = random(UV + TIME) * 2.0 - 1.0;

    color.rgb += noise * noise_intensity;

    COLOR = color;
}