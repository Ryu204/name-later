shader_type canvas_item;

uniform float iTime;
uniform vec2 camera_position;
uniform vec2 screen_size;
const vec3 STAR_COLOR = vec3(0.1, 0.1, 0.1);

float rand(vec2 st) {
    vec2 r = fract(sin(st) * 2.7644437);
    return fract(r.y * 276.44437 + r.x);
}

float particles(vec2 st) {
    float r = rand(floor(st));
    return 0.01 + smoothstep(0.995, 1.0, r) * max(0.0, sin(r * 34433.0 + iTime));
}

vec3 avg(vec2 st, float a) {
    vec2 A = vec2(0.0, a);
    return STAR_COLOR * (
        particles(st) +
        particles(st + A) +
        particles(st + A.yx) +
        particles(st - A) +
        particles(st - A.yx)
    );
}

vec3 stars(vec2 st) {
    vec3 color = vec3(0.0);
    for (float i = 5.0; i > 0.0; --i) {
        color += mix(color, avg(st, i), 1.5);
    }
    return color + particles(st);
}

void fragment() {
	vec2 screen_position = SCREEN_UV * screen_size - screen_size / 2.0;
    vec2 uv = screen_position + camera_position;
	uv /= 5.0;
    COLOR = vec4(stars(uv), 0.5);
}
