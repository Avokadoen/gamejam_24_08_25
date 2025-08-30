shader_type canvas_item;

uniform float scroll_rate = 3;
uniform float time = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv_offset = vec2(time * scroll_rate, 0);
	vec4 color = texture(TEXTURE, UV + uv_offset);
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
