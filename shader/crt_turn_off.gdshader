shader_type canvas_item;

uniform vec4 FADE_COLOR: source_color = vec4(0.0859f, 0.0937f, 0.1328f, 1.0f);
uniform float BUFFER = 2.0f;
uniform float SCALE_SPEED = 1.5f;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest, repeat_disable;
uniform float progress: hint_range(0.0, 1.0, 0.001) = 0.;

void fragment() {
	float onePixelScale = ((1. / SCREEN_PIXEL_SIZE).y - 1.0f) / (1. / SCREEN_PIXEL_SIZE).y;
    
	float time = mod(progress * 4.0f, 1.0f / SCALE_SPEED + 1.0f + BUFFER * 2.0f);
	time = clamp(time - BUFFER, 0.0, 1.0f / SCALE_SPEED + 1.0f);
    
    float scaleTime = clamp(time * SCALE_SPEED, 0.0f, onePixelScale);
    float fadeTime = clamp(time - onePixelScale / SCALE_SPEED, 0.0f, 1.0f);
        
	vec2 uv = FRAGCOORD.xy / (1. / SCREEN_PIXEL_SIZE).xy;
    vec2 scaledUV = vec2(
        (uv.x - 0.5f) * (1.0f - scaleTime) + 0.5f,
        (uv.y - 0.5f) / (1.0f - scaleTime) + 0.5f
    );
    
	vec4 textureColor = texture(SCREEN_TEXTURE, scaledUV)
		+ vec4(scaleTime, scaleTime, scaleTime, 0);
    
	float fadeOutLevel = 1.0f - fadeTime;
    float cropPixel = min(
        clamp(
            sign(
                abs(scaleTime / 2.0f - 0.5) 
                - abs(uv.y - 0.5f)
            )
            , 0.0f, 1.0f
        ), 
        clamp(
            sign(
                1.0f - fadeTime
                - abs(uv.x - 0.5f)
            ),
            0.0f, 
            1.0f
        )
    );
	vec4 result = mix(
        FADE_COLOR, 
        mix(FADE_COLOR, textureColor, fadeOutLevel), 
        cropPixel
    );
	
    COLOR = result;
}
