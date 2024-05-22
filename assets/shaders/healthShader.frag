#pragma header


uniform float healthVal;
uniform vec4 HealthColor = vec4(0.64,0.08,0.08,1.0);
uniform float WaveSpeed;
uniform float WavePeriod;
uniform float WaveAmplitude;
uniform float time;
void main(void)
{
    vec2 UV = getCamPos(openfl_TextureCoordv.xy);

    // Construct sinewave value that varies horizontally based on speed and period
    float sin_wave = sin((time + (UV.y / WavePeriod)) * WaveSpeed);

    // Normalize to 0..1
    float scaled_sin_wave = (sin_wave * 0.5) + 0.5;

    // Value to smoothly lower the amplitude near the full and empty health levels
    float wave_amp_scale = min(smoothstep(1.0, 1.0 - WaveAmplitude, healthVal), smoothstep(0.0, WaveAmplitude * 2.0, healthVal));

    // Compute the wave testing value
    float wave_test_val = healthVal - scaled_sin_wave * WaveAmplitude * wave_amp_scale;

    // Test it against the fragment x value
    float wave = UV.x < wave_test_val ? 1.0 : 0.0; // Changed the test condition

    // Output
    gl_FragColor.rgb = HealthColor.rgb;
    gl_FragColor.a = wave * HealthColor.a;
}