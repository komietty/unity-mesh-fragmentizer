#ifndef CUSTOM_LIGHTING_INCLUDED
#define CUSTOM_LIGHTING_INCLUDED

#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

sampler2D _MainTex;
float4 _MainTex_ST;
float _Smoothness;
float4 _ATint;
float _Metallic;

struct appdata
{
	float4 vertex : POSITION;
	float3 normal : NORMAL;
	float2 uv : TEXCOORD0;
};

struct v2f
{
	float4 vertex : SV_POSITION;
	float2 uv : TEXCOORD0;
	float3 normal : TEXCOORD1;
	float3 wpos : TEXCOORD2;
    #if defined(VERTEXLIGHT_ON)
		float3 vertexLightColor : TEXCOORD3;
	#endif
};

void ComputeVertexLightColor (inout v2f i)
{
    #if defined(VERTEXLIGHT_ON)
		i.vertexLightColor = Shade4PointLights(
			unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
			unity_LightColor[0].rgb, unity_LightColor[1].rgb,
			unity_LightColor[2].rgb, unity_LightColor[3].rgb,
			unity_4LightAtten0, i.worldPos, i.normal
		);
	#endif
};
			
v2f vert (appdata v)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	o.normal = UnityObjectToWorldNormal(v.normal);
	o.wpos = mul(unity_ObjectToWorld, v.vertex);
    ComputeVertexLightColor(o);
	return o;
}

UnityLight CreateLight (v2f i)
{
	UnityLight light;
	#if defined(POINT) || defined(SPOT) || defined(POINT_COOKIE)
		light.dir = normalize(_WorldSpaceLightPos0.xyz - i.wpos);
	#else
		light.dir = _WorldSpaceLightPos0.xyz;
	#endif

    UNITY_LIGHT_ATTENUATION(attenuation, 0, i.wpos);
	light.color = _LightColor0.rgb * attenuation;
	light.ndotl = DotClamped(i.normal, light.dir);
	return light;
};

UnityIndirect CreateIndirectLight (v2f i)
{
	UnityIndirect indirectLight;
	indirectLight.diffuse = 0;
	indirectLight.specular = 0;

	#if defined(VERTEXLIGHT_ON)
		indirectLight.diffuse = i.vertexLightColor;
	#endif
	#if defined(FORWARD_BASE_PASS)
	    indirectLight.diffuse += max(0, ShadeSH9(float4(i.normal, 1)));
	#endif
	
	return indirectLight;
};
			
fixed4 frag (v2f i) : SV_Target
{
    i.normal = normalize(i.normal);
	float3 albedo = tex2D(_MainTex, i.uv).rgb * _ATint.rgb;
	float3 viewerDir = normalize(_WorldSpaceCameraPos - i.wpos);
	float3 specularTint;
	float oneMinusReflectivity;

	albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);
	
	return UNITY_BRDF_PBS(
        albedo,
        specularTint,
        oneMinusReflectivity,
        _Smoothness,
        i.normal,
        viewerDir,
        CreateLight(i),
        CreateIndirectLight(i)
    );
}
#endif