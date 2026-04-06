shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0) = .5;

void fragment() {
	float p = 1. - step(progress, UV.x);
	COLOR.a *= p;
}
