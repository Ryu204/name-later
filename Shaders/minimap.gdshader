shader_type canvas_item;
void fragment(){
    COLOR = texture(TEXTURE, UV);
	
	if (COLOR.a == 0.0) {
        // Set it to gray with full opacity
        COLOR.rgb = vec3(0.2); // Gray color
        COLOR.a = 1.0;
    }
    // make the pixel completely transparent
    // if it's outside the radius of the circle
    COLOR.a = 1.0 - round(distance(UV, vec2(0.5, 0.5)));
}