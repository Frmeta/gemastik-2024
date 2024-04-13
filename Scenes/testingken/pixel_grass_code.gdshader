shader_type spatial;

uniform sampler2D texture_albedo;
uniform vec4 albedo;

void vertex() {
	VERTEX.x += cos(TIME)*(VERTEX.y+0.5)*0.2;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA = albedo.a * albedo_tex.a;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
