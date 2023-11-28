shader_type spatial;
uniform sampler2D sdf_texture;
uniform float thickness: hint_range(0, 1) = 0.5;
uniform float softness: hint_range(0, 1) = 0.0;
uniform vec4 colour :  source_color = vec4(1., 1., 1., 1.0);
uniform vec4 outline_colour : source_color = vec4(1., 1., 1., 1.0);
uniform float outline_thickness : hint_range(0, 1) = 0.0; uniform float outline_softness : hint_range(0, 1) = 0.1;
void fragment(){

	float a = texture(sdf_texture, UV).r;
	float outline = smoothstep(outline_thickness - outline_softness, outline_thickness + outline_softness, a); 
	a = smoothstep(1.0 - thickness - softness, 1.0 - thickness + softness, a);
	ALPHA = a;
	
	ALBEDO = mix(outline_colour.rgb, colour.rgb, outline);
}