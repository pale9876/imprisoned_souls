shader_type canvas_item;

uniform bool active = false;
uniform float progress: hint_range(0., 1., .001) = 0.;
uniform sampler2D trans_curve;
uniform sampler2D anim_curve;


void fragment() {
	vec2 enlarged_uv = vec2(UV.x, UV.y * 1.0015);
	vec4 y_scanlines = texture(TEXTURE, enlarged_uv);
	
	y_scanlines.a *= float(mod(UV.x, .02) <= .002);
	
	vec4 base_texture = COLOR;
	base_texture.a *= texture(trans_curve, vec2(progress)).r;
	
	float mixed_curve = texture(anim_curve, vec2(progress)).r;
	
	COLOR = mix(
		base_texture,
		y_scanlines,
		mixed_curve * y_scanlines.a
	);
	
	
}
