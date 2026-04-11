shader_type canvas_item;


uniform float radius: hint_range(0., 1., .001) = .26;


void fragment() { 
	float tp_circle = step(distance(UV, vec2(.5)), radius);
	
	COLOR.a -= tp_circle;
}
