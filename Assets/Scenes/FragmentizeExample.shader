Shader "Unlit/FragmentizeExample"
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
			Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}
			LOD 100
            CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile _ VERTEXLIGHT_ON
			#define FORWARD_BASE_PASS
            #pragma vertex vert_remesh
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "/Assets/Packages/unity-gist/Cginc/SimplexNoise.cginc"
            #include "/Assets/Packages/unity-gist/Wireframe/CustomLighting.cginc"

			float _Amount;
			float3 _DeltaPos;
			float  _NoiseCoef;
            v2f vert_remesh (appdata v, uint vid : SV_VertexID) {
                v2f o;
				uint tid = (uint)vid / 3;
				o.wpos = mul(unity_ObjectToWorld, v.vertex);
				o.wpos += _DeltaPos;
				o.wpos += snoise3D(tid) * _NoiseCoef * 0.5;
				o.vertex = mul(UNITY_MATRIX_VP, float4(o.wpos, 1.0));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				ComputeVertexLightColor(o);
                return o;
            }
            ENDCG
        }
		Pass {
			Tags {"LightMode" = "ForwardAdd"}
			Blend One One
			ZWrite Off

			CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile_fwdadd
			#pragma vertex vert
			#pragma fragment frag
            #include "/Assets/Packages/unity-gist/Wireframe/CustomLighting.cginc"
			ENDCG
		}

    }
}
