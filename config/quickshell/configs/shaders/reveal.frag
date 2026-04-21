#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(binding = 1) uniform sampler2D source;

layout(std140, binding = 0) uniform buf {
    float radius;
    float cx;
    float cy;
};

void main() {
    vec2 uv = qt_TexCoord0;

    float dist = distance(uv, vec2(cx, cy));

    vec4 color = texture(source, uv);

    // borde suave 🔥
    float edge = smoothstep(radius, radius - 0.02, dist);

    fragColor = vec4(color.rgb, color.a * edge);
}