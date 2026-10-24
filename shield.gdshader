shader_type canvas_item;
render_mode unshaded, blend_mix;

uniform sampler2D gradient_2d;
uniform vec4 shield_color: source_color =vec4(.42, .62, 1., 1.);
uniform float interior_alpha: hint_range(0., 1.) = 0.07;
uniform float rim_width: hint_range(.005, .15) = 0.035;
uniform float rim_strength: hint_range(0., 5.) = 2.2;
uniform float glow_strength: hint_range(0., 3.) = 0.8;

// ─────────────────────────────
// 육각형 패턴
// ─────────────────────────────

uniform float hex_scale: hint_range(4.0, 40.0) = 18.0;
uniform float hex_line_width: hint_range(0.005, 0.08) = 0.025;
uniform float hex_strength: hint_range(0.0, 2.0) = 0.30;
uniform float flow_strength: hint_range(0.0, 2.0) = 0.65;
uniform float flow_speed: hint_range(0.0, 3.0) = 0.35;
uniform float flow_width: hint_range(0.05, 1.0) = 0.25;


uniform float pond_alpha: hint_range(0., 1., .01) = 1.;


float hex_distance(vec2 p)
{
    p.y *= 1.1547005;

    vec2 r = vec2(1.0, 1.7320508);
    vec2 h = r * 0.5;

    vec2 a = mod(p, r) - h;
    vec2 b = mod(p - h, r) - h;

    vec2 gv = dot(a, a) < dot(b, b) ? a : b;

    return max(
        abs(gv.x) * 0.8660254 + abs(gv.y) * 0.5,
        abs(gv.y)
    );
}


// ─────────────────────────────
// Fragment
// ─────────────────────────────

void fragment()
{
    // 원형 좌표
    vec2 p = (UV - vec2(0.5)) * 2.0;
    float dist = length(p);

    // 원 바깥 제거
    if (dist >= 1.) discard;

    // 가장자리 마스크
    float edge = smoothstep(1. - rim_width, 1., dist);

    float glow = exp(- max(1. - dist, 0.) * 24.);

    float curvature = smoothstep(.05, 1., dist);

    float interior = mix(
        0.12,
        0.42,
        curvature
    );

    // 육각형 격자
    vec2 hex_uv = UV * hex_scale;

    float d = hex_distance(hex_uv);

    // 육각형 경계선 생성
    float hex_line = 1.0 - smoothstep(
        hex_line_width,
        hex_line_width + 0.025,
        abs(d - 0.5)
    );

    // 중앙에서는 약하고 외곽에서는 잘 보이도록 처리
    float hex_mask = smoothstep(
        0.15,
        0.95,
        dist
    );

    // ─────────────────────────
    // 표면을 흐르는 빛
    // ─────────────────────────

    // 각 육각형 선을 따라 시간에 따른 밝기 변화 생성
    float flow = sin(
        hex_uv.x * 0.7 +
        hex_uv.y * 0.35 -
        TIME * flow_speed * 4.0
    );

    flow = flow * 0.5 + 0.5;

    // 특정 구간에서만 빛이 강해지도록 처리
    float flow_light = smoothstep(
        1.0 - flow_width,
        1.0,
        flow
    );

    // 육각형 선에만 빛을 적용
    float animated_hex = hex_line * (
        hex_strength +
        flow_light * flow_strength
    );

    animated_hex *= hex_mask;

    // 미세한 전체 에너지 변화
    float pulse = 0.96 + 0.04 * sin(
        TIME * 0.8
    );

    // ─────────────────────────
    // 최종 색상
    // ─────────────────────────

    vec3 color = shield_color.rgb * interior;

    // 육각형 패턴과 이동하는 빛
    color += shield_color.rgb * animated_hex;

    // 테두리 발광
    color += shield_color.rgb *
        edge *
        rim_strength;

    // 부드러운 외곽 빛 번짐
    color += shield_color.rgb *
        glow *
        glow_strength *
        0.25;

    color *= pulse;

    // 투명도
    float alpha = mix(
        interior_alpha,
        0.95,
        edge
    );

    alpha += animated_hex * 0.10;
    alpha += glow * 0.08;

    vec4 _color = vec4(
        color,
        clamp(alpha, 0.0, 1.0)
    );
	vec4 _texture = texture(gradient_2d, UV);
	float _alpha = _texture.a * _color.a * pond_alpha;
	COLOR = vec4(_color.rgb, _alpha);
}











	