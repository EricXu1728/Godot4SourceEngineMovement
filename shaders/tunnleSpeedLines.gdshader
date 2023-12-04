shader_type particles;

uniform float tunnel_radius : hint_range( 0.0, 10.0 ) = 2.0;
uniform float tunnel_length : hint_range( 0.0, 100.0 ) = 50.0;

float rand_from_seed(in uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
	s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

void process() {

	if (RESTART) {
		uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
		// set particle position in model space with tunnel_radius and tunnel_length
		float angle_rand = rand_from_seed( alt_seed1 ) * 6.283185;
		TRANSFORM[3].x = tunnel_length ;
		TRANSFORM[3].y = sin( angle_rand ) * tunnel_radius;
		TRANSFORM[3].z = cos( angle_rand ) * tunnel_radius;

		// calculate VELOCITY in negative x direction
		VELOCITY.x = -tunnel_length / LIFETIME;
		
		

		// calculate 2D normal and send it to "Pass 1" shader with CUSTOM variable
		CUSTOM.yz = vec2( sin( angle_rand - 1.570796 ), cos( angle_rand - 1.570796 ) );
		//CUSTOM.x = 3.1
	}
}