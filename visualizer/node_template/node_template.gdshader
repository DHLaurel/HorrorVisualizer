shader_type spatial;
render_mode unshaded;

uniform sampler2D texture_albedo : hint_default_white;
uniform float time_speed = 1.0; // Speed of the glitch effect
uniform float glitch_intensity = 0.5; // Overall intensity of the glitch
uniform float noise_scale = 50.0; // Scale of the noise pattern
uniform vec3 color_shift = vec3(0.1, -0.1, 0.0); // RGB channel offset for horror effect

// Random noise function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function for glitch effect
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

// Glitch distortion function
vec2 glitch_distort(vec2 uv, float intensity) {
    float n = noise(uv * noise_scale + TIME * time_speed) * intensity;
    uv.x += n * 0.1; // Horizontal shift
    uv.y += n * 0.05 * sin(TIME); // Vertical jitter
    return uv;
}

// Fragment shader
void fragment() {
    // Get base texture color
    vec4 albedo = texture(texture_albedo, UV);

    // Apply glitch distortion to UV coordinates
    vec2 distorted_uv = glitch_distort(UV, glitch_intensity);

    // Sample the texture again with distorted UVs
    vec4 distorted_color = texture(texture_albedo, distorted_uv);

    // Add color channel shift for horror effect
    vec3 shifted_color = distorted_color.rgb;
    shifted_color.r += color_shift.r * glitch_intensity;
    shifted_color.g += color_shift.g * glitch_intensity;
    shifted_color.b += color_shift.b * glitch_intensity;

    // Add scanlines
    float scanline = sin(UV.y * 1000.0 + TIME * 5.0) * 0.1 * glitch_intensity;
    shifted_color += vec3(scanline, scanline * 0.5, scanline * 0.8);

    // Clamp the final color to avoid over-saturation
    ALBEDO = clamp(shifted_color, 0.0, 1.0);
    ALPHA = albedo.a;

    // Add subtle noise overlay
    float noise_value = noise(UV * noise_scale + TIME) * 0.1 * glitch_intensity;
    ALBEDO += vec3(noise_value);
}

// Vertex shader (optional, for slight vertex jitter)
void vertex() {
    VERTEX.xyz += normalize(NORMAL) * random(NORMAL.xy + TIME) * 0.05 * glitch_intensity;
}