﻿Shader "Custom/DiffuseShader" {
	Properties {
		_Color ("Color", Color) = (1, 1, 1, 1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Bump ("Bump", 2D) = "bump" {}
		_MainTint ("Diffuse Tint", Color) = (0.75, 0.25, 0.75, 1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf CustomDiffuse

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
        sampler2D _Bump;  
		fixed4 _Color;
		fixed4 _MainTint;

		struct Input {
			float2 uv_MainTex;
            float2 uv_Bump;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			
            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		inline float4 LightingCustomDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten) {
			float difLight = max(0, dot (s. Normal, lightDir));
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * difLight * atten * 2;
			col.a = s.Alpha;
			return col;
		}
		
		ENDCG
	} 
	FallBack "Diffuse"
}
