#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_COLOR_SHADER


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// hash from iq's live coded apple
float hash(float n)
{
	return 1.0;
	//return fract(sin(n)*43758.54);
}

float roadpoint(float n)
{
	if (hash(n+0.5) > 0.75)
		return 0.0;
	float z = (hash(n)-0.5)*2.2;
	return sign(z) * pow(abs(z),2.0);
}

// cubic interpolator
float noise(float x)
{
	float p = floor(x);
	float f = fract(x);
	float p0 = roadpoint(p);
	float p1 = roadpoint(p+1.0);
	float p2 = roadpoint(p+2.0);
	float p3 = roadpoint(p+3.0);
	float a = (-p0*0.5 + 1.5*p1 - 1.5*p2 + p3*0.5);
	float b = p0 - 2.5*p1 + 2.0*p2 - 0.5*p3;
	float c = 0.5*p2 - 0.5*p0;
	float d = p1;
	return d + f*(c + f*(b + f*a));
}	

float road_offset(float pos)
{
	return noise(pos/80.0)*10.0
		+ noise(pos/500.0)*80.0; // add some "long-range" curves
}

float road_slope(float pos)
{	
	return (road_offset(pos+4.0) - road_offset(pos-4.0))/8.0;	
}

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.yy;

	float y = position.y-0.62;
	if (position.y > 0.6) {
		gl_FragColor = vec4(0.2, 0.6, 1.0, 1.0);
		// enable this "return" statement not to draw the ceiling
		return;
	} 
	y = -y;

	// y ranges from 0.02 to 0.62
	float z = 1.0 / y; // yscreen = y/z, so z = y / yscreen
	// z ranges from ~1.5 to 50
	float speed = 4.5;
	float dist = pow(z,0.75); // fudge this so the distance doesn't get too aliasy
	float spacing = 20.0;
	float bottom_trackpos = time*speed*spacing + 1.4*spacing;
	float trackpos = (dist+time*speed)*spacing;
	float xcenter = -resolution.x/resolution.y*0.5;

	// compute the road "view vector" based on the bottom of the screen
	float road_point = road_offset(bottom_trackpos);

	// using average_slope instead of base_slope smooths the camera movement
	float averaged_slope = (road_slope(bottom_trackpos) + road_slope(bottom_trackpos - speed)) / 2.0;
	float base_slope = road_slope(bottom_trackpos);
	float slope = averaged_slope*0.75; // at 1.0 we're always looking strictly forward
	float slope_offset = (0.62-y) * slope * 8.0; // dunno why 8.0

	float x = (position.x + xcenter - slope_offset) * z; // xscreen = x/z, so x = xscreen * z

	x -= road_point;
	
	// compute the course path at the current point
	x += road_offset(trackpos);

	float xa = abs(x);
	float phase = sin(trackpos);
	float state = phase > 0.0 ? 0.0 : 1.0;
	float darken = state == 0.0 ? 0.3 : 0.2;
	if (xa > 1.6)
		gl_FragColor = vec4(0.8,0.5,0,1) * mix(1.0,darken,y);
	else if (xa > 1.1) {
		gl_FragColor = (state==0.0 ? vec4(0.4,0.3,0,1) : vec4(0.3,0.2,0.0,1));
	}
	else if (state==0.0 && abs(xa-0.0) < 0.03)
		gl_FragColor = vec4(1,1,0,1);
	else
		gl_FragColor = vec4(0.5,0.5,0.5,1.0);
}
