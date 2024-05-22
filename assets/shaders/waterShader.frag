#pragma header
uniform float iTime;

#define tau 6.28318530718

float sin01(float x) {
	return (sin(x*tau)+1.)/2.;
}
float cos01(float x) {
	return (cos(x*tau)+1.)/2.;
}

// rand func from theartofcode (youtube channel)
vec2 rand01(vec2 p) {
    vec3 a = fract(p.xyx * vec3(123.5, 234.34, 345.65));
    a += dot(a, a+34.45);
    
    return fract (vec2(a.x * a.y, a.y * a.z));
}

float circ(vec2 uv, vec2 pos, float r) {
    return smoothstep(r, 0., length(uv - pos));
}

float smoothFract(float x, float blurLevel) {
	return pow(cos01(x), 1./blurLevel);
}

float manDist(vec2 from, vec2 to) {
    return abs(from.x - to.x) + abs(from.y - to.y);
}


float distFn(vec2 from, vec2 to) {
	float x = length (from - to);
    return pow (x, 4.);
}

float voronoi(vec2 uv, float t, float seed, float size) {
    
    float minDist = 100.;
    
    float gridSize = size;
    
    vec2 cellUv = fract(uv * gridSize) - 0.5;
    vec2 cellCoord = floor(uv * gridSize);
    
    for (float x = -1.; x <= 1.; ++ x) {
        for (float y = -1.; y <= 1.; ++ y) {
            vec2 cellOffset = vec2(x,y);
            
            // Random 0-1 for each cell
            vec2 rand01Cell = rand01(cellOffset + cellCoord + seed);
			
            // Get position of point
            vec2 point = cellOffset + sin(rand01Cell * (t+10.)) * .5;
            
			// Get distance between pixel and point
            float dist = distFn(cellUv, point);
    		minDist = min(minDist, dist);
        }
    }
    
    return minDist;
}

void main(void)
{
    // Center coordinates at 0
    vec2 uv = getCamPos(openfl_TextureCoordv.xy);
    
    float t = iTime * .35;
    
	// Distort uv coordinates
    float amplitude = .12;
    float turbulence = .5;
    uv.xy += sin01(uv.x*turbulence + t) * amplitude;
    uv.xy -= sin01(uv.y*turbulence + t) * amplitude;
    
	// Apply two layers of voronoi, one smaller   
    float v;
    float sizeDistortion = abs(uv.x)/3.;
    v += voronoi(uv, t * 2., 0.5, 2.5 - sizeDistortion);
    v += voronoi(uv, t * 4., 0., 4. - sizeDistortion) / 2.;
    
    // Foreground color
    vec3 col = v * vec3(.55, .75, 1.);
    
    // Background color
    col += (1.-v) * vec3(.0, .3, .5);
    
    // Output to screen
	vec4 texture = flixel_texture2D(bitmap, openfl_TextureCoordv);
    gl_FragColor = vec4(col*texture.a,texture.a);
}