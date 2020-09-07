Shader "Unlit/Tessellation"
{
	Properties
	{
		_MainTex ("Albedo", 2D) = "white" {}
		_Smoothness ("Smoothness", Range(0, 1)) = 0.5
		_ATint ("ATint", Color) = (1, 1, 1, 1)
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0.5
		_WireframeColor ("Wireframe Color", Color) = (0, 0, 0)
		_WireframeSmoothing ("Wireframe Smoothing", Range(0, 10)) = 1
		_WireframeThickness ("Wireframe Thickness", Range(0, 10)) = 1
		_Tesselletionfactor0 ("TesselletionFactor0", Range(1, 64)) = 1.0
		_Tesselletionfactor1 ("TesselletionFactor1", Range(1, 64)) = 1.0
		_TessellationEdgeLen ("Tessellation Edge Length", Range(0.1, 1)) = 0.5

	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma target 4.6
			#pragma shader_feature _TESSELLATION_EDGE
			#include "Tessellation.cginc"
			#define _TESSELLATION_EDGE true
			#pragma vertex vert
			#pragma hull hurl
			#pragma domain dmin
			#pragma geometry geom
			#pragma fragment frag
			ENDCG
		}
	}
}