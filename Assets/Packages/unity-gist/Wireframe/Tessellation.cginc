#ifndef TESSELLATION_INCLUDED
#define TESSELLATION_INCLUDED

#include "UnityCG.cginc"

float3 _WireframeColor;
float _WireframeSmoothing;
float _WireframeThickness;
float _Tesselletionfactor0;
float _Tesselletionfactor1;
float _TessellationEdgeLen;

struct VertexData
{
	UNITY_VERTEX_INPUT_INSTANCE_ID
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
    float2 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
};

struct v2t
{
	float4 vertex : INTERNALTESSPOS;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
    float2 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
};

struct t2g
{
	float4 vertex : SV_POSITION;
	float3 normal : TEXCOORD3;
	float3 wpos : TEXCOORD4;
};

struct TessellationFactors
{
    float edge[3] : SV_TessFactor;
    float inside : SV_InsideTessFactor;
};

struct g2f
{
    t2g data;
	float2 barycentricCoordinates : TEXCOORD5;
};
		
v2t vert (VertexData v)
{
	v2t p;
    p.vertex = v.vertex;
    p.normal = v.normal;
    p.tangent = v.tangent;
    p.uv1 = v.uv1;
    p.uv2 = v.uv2;
    return p;
}

[UNITY_domain("tri")]
[UNITY_outputcontrolpoints(3)]
[UNITY_outputtopology("triangle_cw")]
[UNITY_partitioning("fractional_even")]
[UNITY_patchconstantfunc("MyPatchConstantFunction")]
v2t hurl (InputPatch<v2t, 3> patch, uint id : SV_OutputControlPointID)
{
    return patch[id];
}

float TessellationEdgeFactor (v2t cp0, v2t cp1)
{
    #if defined(_TESSELLATION_EDGE)
    	float3 p0 = mul(unity_ObjectToWorld, float4(cp0.vertex.xyz, 1)).xyz;
    	float3 p1 = mul(unity_ObjectToWorld, float4(cp1.vertex.xyz, 1)).xyz;
    	float edgeLength = distance(p0, p1);
    	return edgeLength / _TessellationEdgeLen;
    #else
    	return _Tesselletionfactor0;
    #endif
}

TessellationFactors MyPatchConstantFunction (InputPatch<v2t, 3> patch)
{
	TessellationFactors f;
    f.edge[0] = TessellationEdgeFactor(patch[1], patch[2]);
    f.edge[1] = TessellationEdgeFactor(patch[2], patch[0]);
    f.edge[2] = TessellationEdgeFactor(patch[0], patch[1]);
	f.inside = (f.edge[0] + f.edge[1] + f.edge[2]) * (1 / 3.0);
	return f;
}

[UNITY_domain("tri")]
t2g dmin (TessellationFactors factors, OutputPatch<v2t, 3> patch, float3 barycentricCoordinates : SV_DomainLocation)
{
	VertexData data;
	#define MY_DOMAIN_PROGRAM_INTERPOLATE(fieldName) data.fieldName = patch[0].fieldName * barycentricCoordinates.x + patch[1].fieldName * barycentricCoordinates.y + patch[2].fieldName * barycentricCoordinates.z;
	MY_DOMAIN_PROGRAM_INTERPOLATE(vertex)
	MY_DOMAIN_PROGRAM_INTERPOLATE(normal)
	MY_DOMAIN_PROGRAM_INTERPOLATE(tangent)
	MY_DOMAIN_PROGRAM_INTERPOLATE(uv1)
	MY_DOMAIN_PROGRAM_INTERPOLATE(uv2)

	t2g o;
	o.vertex = UnityObjectToClipPos(data.vertex);
	o.normal = UnityObjectToWorldNormal(data.normal);
	o.wpos = mul(unity_ObjectToWorld, data.vertex);
	return o;
}

[maxvertexcount(3)]
void geom (triangle t2g i[3], inout TriangleStream<g2f> stream)
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
			
fixed4 frag (g2f i) : SV_Target
{
    i.data.normal = normalize(i.data.normal);
	float3 barys;
    barys.xy = i.barycentricCoordinates;
    barys.z = 1 - barys.x - barys.y;
    float3 deltas = fwidth(barys);
	float3 smoothing = deltas * _WireframeSmoothing;
    float3 thickness = deltas * _WireframeThickness;
    barys = smoothstep(thickness, thickness + smoothing, barys);
    float minBary = min(barys.x, min(barys.y, barys.z));
    return float4(lerp(_WireframeColor, 0, minBary), 1.0);
}

#endif