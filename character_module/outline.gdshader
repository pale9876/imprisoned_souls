shader_type canvas_item;


uniform vec4 color: source_color = vec4(1.);
uniform float thickness: hint_range(0.0, 1.0, 0.01) = .5;
const float max_line_thickness = 4.;


void fragment() {
	vec4 _color = texture(TEXTURE, UV);
	vec2 size = TEXTURE_PIXEL_SIZE * thickness;
	float _outline = _color.a;
	
	_outline += texture(TEXTURE, UV + vec2(size.x, 0.)).a;
	_outline += texture(TEXTURE, UV - vec2(size.x, 0.)).a;
	_outline += texture(TEXTURE, UV + vec2(0., size.y)).a;
	_outline += texture(TEXTURE, UV - vec2(0., size.y)).a;
	_outline = min(_outline, 1.);
	
	COLOR = mix(_color, color, _outline - _color.a);
	
}
