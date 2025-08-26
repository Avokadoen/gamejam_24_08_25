shader_type canvas_item;

uniform float whiteness_to_alpha_modifier = 3;
uniform float scroll_rate = 0.3;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv_offset = vec2(TIME * scroll_rate, 0);
	vec4 color = texture(TEXTURE, UV + uv_offset);
	float whiteness = (color.r + color.g + color.b) / whiteness_to_alpha_modifier;
	color.a = whiteness;
	
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
