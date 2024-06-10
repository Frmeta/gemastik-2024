shader_type canvas_item;

uniform bool enabled = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (enabled){
		float s = 0.0, v = 0.0;
		vec2 ires = 1.0 / SCREEN_PIXEL_SIZE;
		vec2 uv = (FRAGCOORD.xy/ ires) * 2.0 - 1.;
	    float itime = (TIME-2.0)*58.0;
		vec3 col = vec3(0);
	    vec3 init = vec3(sin(itime * .0032)*.3, .35 - cos(itime * .005)*.3, itime * 0.002);
		for (int r = 0; r < 100; r++) 
		{
			vec3 p = init + s * vec3(uv, 0.05);
			p.z = fract(p.z);
	        // Thanks to Kali's little chaotic loop...
			for (int i=0; i < 10; i++)	p = abs(p * 2.04) / dot(p, p) - .9;
			v += pow(dot(p, p), .7) * .06;
			col +=  vec3(v * 0.2+.4, 12.-s*2., .1 + v * 1.) * v * 0.00003;
			s += .025;
		}
		COLOR = vec4(clamp(col, 0.0, 1.0), 1.0);
	}	
}

//void light() {
	//// Called for every pixel for every light affecting the CanvasItem.
	//// Uncomment to replace the default light processing function with this one.
//}