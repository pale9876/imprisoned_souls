shader_type canvas_item;


uniform float radius: hint_range(0., 1., .001) = .26;
uniform float width = .01;
uniform float alpha = .75;

void fragment() { 
	COLOR.a = 0.;
	
	float outer_circle = step(distance(UV, vec2(.5)), .26);
	float tp_circle = step(distance(UV, vec2(.5)), radius - width);
	
	COLOR.a = (outer_circle - tp_circle) * alpha;
}
