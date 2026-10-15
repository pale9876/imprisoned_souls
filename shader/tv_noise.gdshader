shader_type canvas_item;


uniform float alpha: hint_range(0.0, 1.0, 0.001) = 1.;

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment()
{
	vec2 uv = FRAGCOORD.xy / (1. / SCREEN_PIXEL_SIZE);
	vec4 clr = COLOR;

	float t = mod(TIME, 360.);
	float t2 = floor(t * .6);
	float x,y,yt,xt;
	
	yt= abs(cos(t)) * rand(vec2(t,t)) * 100.0;
	xt= sin(360.0 * rand(vec2(t,t))) * 0.25;
	
	if (xt < 0.0)
	{
		xt = .125;
    }
	
	x=uv.x - xt * exp( - pow(uv.y * 100. - yt, 2.) / 24.);
	y=uv.y;
	
	uv.x=x;
	uv.y=y;
	yt = 0.5 * cos((yt / 100.) / 100. * 360.);
	
	float yr = .1 * cos((yt / 100.) / 100. * 360.);
	
	if (UV.y > yt && UV.y < yt+rand(vec2(t2,t)) * .25)
	{
		float md = mod(x * 100., 10.);
		if (md * sin(t) > sin(yr * 360.) || rand(vec2(md,md)) > .4)
		{
			vec4 org_c = texture(TEXTURE, uv);
			float colx = rand(vec2(t2,t2)) * 0.75;
			float coly = rand(vec2(uv.x+t,t));// * 0.5;
			float colz = rand(vec2(t2,t2));// * 0.5;
			clr = vec4(org_c.x + colx,org_c.y + colx,org_c.z + colx , 0.);
		}
	}
    else if (y < cos(t) && mod(x*40., 2.) > rand(vec2(y*t,t*t)) * 1. || mod(y * 12., 2.) < rand(vec2(x,t)) * 1.)
	{
        if (rand(vec2(x+t,y+t))>0.8)
		{
			clr = vec4(rand(vec2(x*t,y*t)),rand(vec2(x*t,y*t)),rand(vec2(x*t,y*t)), 0.);
        }
        else 
        {
			clr = texture(TEXTURE, uv);
        }
    }
    else
	{
		uv.x = uv.x + rand(vec2(t,uv.y)) * .0087 * sin(y * 2.);
		clr = texture(TEXTURE, uv);
	}
	
	COLOR = vec4(vec3(clr.rgb), alpha);

}
