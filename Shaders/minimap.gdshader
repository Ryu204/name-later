shader_type canvas_item;

uniform vec2 direction;

#define LINESIZE 0.01
#define THETA 2.0
#define PI 3.14159265359

// Calculate the Euclidean distance
float dist(vec2 uv) {
    return sqrt(dot(uv, uv));
}

vec2 rotate(vec2 v, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(
        c * v.x - s * v.y, // x-component
        s * v.x + c * v.y  // y-component
    );
}

// Calculate the cosine similarity
float getCos(vec2 a, vec2 b) {
    return dot(a, b) / (dist(a) * dist(b));
}

// Function to create the scanning area
float drawArea(vec2 uv, float time) {
    vec2 st = rotate(direction, THETA / 2.0);
    vec2 ed = rotate(direction, -THETA / 2.0);
    if (dist(uv) > 0.7 || getCos(st, uv) < cos(THETA) || getCos(ed, uv) < cos(THETA))
        return 0.1;
    return 1.0;
}

void fragment() {
    // Get the texture color
    vec4 base_color = texture(TEXTURE, UV);

    // Set a default background if transparent
    if (base_color.a <= 0.05) {
        base_color.rgb = vec3(0.1, 0.15, 0.1); // Green tone
        base_color.a = 1.0;
    }

    // Calculate distance from the center
    float d = distance(UV, vec2(0.5));

    // Handle circle transparency
    if (d > 0.5) {
        base_color.a = 0.0; // Outside the circle
    } else if (d > 0.45) {
        base_color.rgb = vec3(0.05, 0.1, 0.05); // Edge of the circle
        base_color.a = 1.0;
    } else {
        // Apply scanning effect inside the circle
        base_color.rgb = base_color.rgb * drawArea(UV - 0.5, TIME);
    }

    // Set the final color
    COLOR = base_color;
}
