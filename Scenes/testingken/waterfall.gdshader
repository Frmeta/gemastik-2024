shader_type spatial;
render_mode unshaded;
 
uniform sampler2D noise_tex;
uniform sampler2D displ_tex;
uniform vec4 top_light_color : source_color;
uniform vec4 top_dark_color : source_color;
uniform vec4 bot_light_color : source_color;
uniform vec4 bot_dark_color : source_color;
uniform float displ_amount = 0.02;
uniform float bottom_foam_threshold = 0.48;
uniform float speed = 0.25;
 
void fragment()
{
	vec2 displ = texture(displ_tex, UV - TIME / 8.0).xy;
	displ = ((displ * 2.0) - 1.0) * displ_amount;
 
	float noise =  texture(noise_tex, vec2(UV.x, UV.y / 3.0 - TIME / 4.0) + displ).x;
	noise =  floor(noise * 4.0) / 4.0;
 
	vec4 col = mix(mix(top_dark_color, bot_dark_color, UV.y), mix(top_light_color, bot_light_color, UV.y), noise);
	col = mix(vec4(1,1,1,1), col, step(UV.y + displ.y, bottom_foam_threshold));
 
	ALBEDO =  col.xyz;
}