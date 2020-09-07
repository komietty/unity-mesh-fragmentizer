#ifndef WIREFRAMING_INCLUDED
#define WIREFRAMING_INCLUDED

#include "UnityCG.cginc"

float3 _WireframeColor;
float _WireframeSmoothing;
float _WireframeThickness;

struct appdata
{
	float4 vertex : POSITION;
	float3 normal : NORMAL;
};

struct v2g
{
	float4 vertex : SV_POSITION;
	float3 normal : TEXCOORD0;
	float3 wpos : TEXCOORD1;
};

struct g2f
{
    v2g data;
	float2 barycentricCoordinates : TEXCOORD2;
};

v2g vert (appdata v)
{
	v2g o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.normal = UnityObjectToWorldNormal(v.normal);
	o.wpos = mul(unity_ObjectToWorld, v.vertex);
	return o;
}

[maxvertexcount(3)]
void geom (triangle v2g i[3], inout TriangleStream<g2f> stream)
{
    float3 p0 = i[0].wpos;
    float3 p1 = i[1].wpos;
    float3 p2 = i[2].wpos;
	float3 triangleNormal = normalize(cross(p1 - p0, p2 - p0));

	g2f g0, g1, g2;
    g0.data = i[0];
    g1.data = i[1];
    g2.data = i[2];

	g0.data.normal = triangleNormal;
	g1.data.normal = triangleNormal;
	g2.data.normal = triangleNormal;

	g0.barycentricCoordinates = float2(1, 0);
    g1.barycentricCoordinates = float2(0, 1);
    g2.barycentricCoordinates = float2(0, 0);

    stream.Append(g0);
    stream.Append(g1);
    stream.Append(g2);
}
			
float4 frag (g2f i) : SV_Target
{
    i.data.normal = normalize(i.data.normal);
	float3 albedo = 0;
	float3 barys;
    barys.xy = i.barycentricCoordinates;
    barys.z = 1 - barys.x - barys.y;
    float3 deltas = fwidth(barys);
	float3 smoothing = deltas * _WireframeSmoothing;
    float3 thickness = deltas * _WireframeThickness;
    barys = smoothstep(thickness, thickness + smoothing, barys);
    float minBary = min(barys.x, min(barys.y, barys.z));
	return float4(lerp(_WireframeColor, albedo, minBary).xyz, 1.0);
}

#endif