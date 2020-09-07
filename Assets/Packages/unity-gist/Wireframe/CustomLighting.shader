Shader "Unlit/CustomLighting"
{
	Properties
	{
		_MainTex ("Albedo", 2D) = "white" {}
		_Smoothness ("Smoothness", Range(0, 1)) = 0.5
		_ATint ("ATint", Color) = (1, 1, 1, 1)
		[Gamma]_Metallic ("Metallic", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Pass
		{
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile _ VERTEXLIGHT_ON
			#pragma vertex vert
			#pragma fragment frag
			#define FORWARD_BASE_PASS
			#include "CustomLighting.cginc"
			ENDCG
		}

		Pass
		{
			Tags {"LightMode" = "ForwardAdd"}
			Blend One One
			ZWrite Off

			CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile_fwdadd
			#pragma vertex vert
			#pragma fragment frag
			#include "CustomLighting.cginc"
			ENDCG
		}
	}
}
