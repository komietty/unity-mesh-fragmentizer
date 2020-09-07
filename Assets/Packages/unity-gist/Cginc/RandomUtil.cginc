#ifndef RANDOMUTIL
#define RANDOMUTIL
#include "ConstantUtil.cginc"
inline float rnd(float2 p) {
    return frac(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
} 
inline float rnd(float2 uv, float salt) {
    uv += float2(salt, 0.0);
    return rnd(uv);
}

inline float3 rnd3(float2 p) {
    return 2.0 * (float3(rnd(p * 1), rnd(p * 2), rnd(p * 3)) - 0.5);
}

// alternative
//float3 rnd3(float2 seed) {
//    float t = sin(seed.x + seed.y * 1e3);
//    return float3(frac(t * 1e4), frac(t * 1e6), frac(t * 1e5));
//}

inline float rndSimple(float i) {
    return frac(sin(dot(float2(i, i * i) * 0.01, float2(12.9898, 78.233))) * 43758.5453);
}
inline float2 rndInsideCircle(float2 p) {
    float d = rnd(p.xy);
    float theta = rnd(p.yx) * PI * 2;
    return d * float2(cos(theta), sin(theta));
}

float2 random_point_on_circle(float2 uv)
{
    float theta = rnd(uv) * PI * 2;
    return float2(cos(theta), sin(theta));
}

// Uniformaly distributed points on a unit sphere
// http://mathworld.wolfram.com/SpherePointPicking.html
float3 random_point_on_sphere(float2 uv)
{
    float u = rnd(uv) * 2 - 1;
    float theta = rnd(uv + 0.333) * PI * 2;
    float u2 = sqrt(1 - u * u);
    return float3(u2 * cos(theta), u2 * sin(theta), u);
}
#endif