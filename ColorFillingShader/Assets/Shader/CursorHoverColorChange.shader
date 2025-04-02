Shader "Custom/CursorHoverColorChange"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Speed ("Speed", Range(0.1 , 5)) = 2
        _Hover ("Hover State", Range(0 , 1)) = 0
        _HoverPos ("Hover Position", Vector) = (-1 , -1 , 0 , 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _Color;
            float _Speed;
            float _Hover;
            float4 _HoverPos;

            float noise(float2 p)
            {
                return frac(sin(dot(p , float2(12.9898 , 78.233))) * 43758.5453);
            }

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_TARGET
            {
                float4 originalColor = _Color;
                float grayscale = dot(originalColor.rgb, float3(0.3 , 0.59 , 0.11));
                float4 greyColor = float4(grayscale , grayscale , grayscale , 1);
                
                float noiseFactor = noise(i.uv * 5);
                float dist = distance(i.uv , _HoverPos.xy);
                float blendFactor = saturate((_Hover - dist * 0.3 + noiseFactor * _Hover) * _Speed);
                return lerp(greyColor , originalColor , blendFactor);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
