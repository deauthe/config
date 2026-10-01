const float DURATION = 0.09;
const float MIN_JUMP_CELLS = 4.0;

float ease(float t) {
    return 1.0 - pow(1.0 - t, 3.0);
}

float sdSegment(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / max(dot(ba, ba), 1e-4), 0.0, 1.0);
    return length(pa - ba * h);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);

    vec2 cur = iCurrentCursor.xy + vec2(iCurrentCursor.z, -iCurrentCursor.w) * 0.5;
    vec2 prev = iPreviousCursor.xy + vec2(iPreviousCursor.z, -iPreviousCursor.w) * 0.5;
    float cellW = max(iCurrentCursor.z, 1.0);
    float cellH = max(iCurrentCursor.w, 1.0);

    float t = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float jump = length(cur - prev);

    if (t >= 1.0 || jump < cellW * MIN_JUMP_CELLS) {
        fragColor = base;
        return;
    }

    float p = ease(t);
    vec2 tail = mix(prev, cur, p);
    float thickness = mix(cellW * 0.35, cellW * 0.1, p);

    float dTrail = sdSegment(fragCoord, tail, cur) - thickness;
    float trail = 1.0 - smoothstep(-1.0, 1.5, dTrail);

    float along = clamp(dot(fragCoord - tail, cur - tail) / max(dot(cur - tail, cur - tail), 1e-4), 0.0, 1.0);
    trail *= mix(0.15, 1.0, along);


    float a = clamp(trail * 0.25 * (1.0 - p), 0.0, 1.0);
    vec3 col = iCurrentCursorColor.rgb;

    fragColor = vec4(base.rgb * (1.0 - a) + col * a, base.a * (1.0 - a) + a);
}
