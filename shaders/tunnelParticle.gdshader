shader_type spatial;

render_mode unshaded, cull_disabled;
uniform sampler2D texture_albedo : hint_default_white;

void vertex() {
	// caculate world_y: get local 2D normal from particle shader variable CUSTOM.yz and transform it from model space to world space
	vec4 world_y = MODEL_MATRIX * vec4( 0.0, INSTANCE_CUSTOM.y, INSTANCE_CUSTOM.z, 0.0);
	// calculate world_z by the cross product of MODEL_MATRIX[0] ( = world_x) and world_y
	vec4 world_z = vec4( cross( MODEL_MATRIX[0].xyz, world_y.xyz ), 0.0 );
	// calculate model space to view space
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4( MODEL_MATRIX[0], world_y, world_z, MODEL_MATRIX[3] );
}

void fragment() {
	ALBEDO = texture( texture_albedo, UV ).rgb; 
	ALPHA = texture( texture_albedo, UV ).a;	
}