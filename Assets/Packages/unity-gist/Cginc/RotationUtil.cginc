#ifndef ROTATION_UTIL
#define ROTATION_UTIL

float4 rotate(float4 v, float angle, float3 axis)
{
    float3 a = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float r = 1.0 - c;
    float3x3 m = float3x3(
        a.x * a.x * r + c,
        a.y * a.x * r + a.z * s,
        a.z * a.x * r - a.y * s,
        a.x * a.y * r - a.z * s,
        a.y * a.y * r + c,
        a.z * a.y * r + a.x * s,
        a.x * a.z * r + a.y * s,
        a.y * a.z * r - a.x * s,
        a.z * a.z * r + c
    );
    return float4(mul(m, v.xyz), 1);
}

float4x4 rotateMtx(float angle, float axis)
{
    float3 a = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float r = 1.0 - c;
    float4x4 m = float4x4(
        a.x * a.x * r + c,
        a.y * a.x * r + a.z * s,
        a.z * a.x * r - a.y * s,
        0, 
        a.x * a.y * r - a.z * s,
        a.y * a.y * r + c,
        a.z * a.y * r + a.x * s,
        0,
        a.x * a.z * r + a.y * s,
        a.y * a.z * r - a.x * s,
        a.z * a.z * r + c,
        0,
        0,
        0,
        0,
        0
    );
    return m;
}

float2 rotate2D(float2 v, float theta)
{
    return float2(v.x * cos(theta) - v.y * sin(theta), v.x * sin(theta) + v.y * cos(theta));
}

float2 lookAt2D(float2 v, float2 currDir, float2 nextDir)
{
    float theta = acos(dot(currDir, nextDir));
    int sn = sign(cross(float3(currDir, 0), float3(nextDir, 0)).z);
    return rotate2D(v, sn * theta);
}

#endif