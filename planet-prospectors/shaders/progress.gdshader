shader_type spatial;

uniform float progress = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float angle = atan(uv.y, uv.x);
    float radius = length(uv);
	float normalized_angle = 1.0 - ((angle - PI/2.0 + PI) / (2.0 * PI));
    normalized_angle = fract(normalized_angle);
	
	if (normalized_angle <= progress && radius <= 0.5) {
        ALBEDO = vec4(1,1,0,1).rgb;
    } else {
		ALBEDO = vec4(0,0,0,1).rgb;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
