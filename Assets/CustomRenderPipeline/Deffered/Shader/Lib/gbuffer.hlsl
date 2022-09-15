
#ifndef _GBUFFER_HLSL
#define _GBUFFER_HLSL
#include "UnityCG.cginc"
struct appdata
{
    float4 vertex : POSITION;
    float4 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 normal : NORMAL;
    float4 vertex : SV_POSITION;
};

sampler2D _GDepth;
sampler2D _GT1;
sampler2D _GT2;
sampler2D _GT3;
sampler2D _GT4;

CBUFFER_START(UnityPerMaterial)
float4 _MainTex_ST;
CBUFFER_END

sampler2D _MainTex;

v2f GBufferVert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.normal = v.normal;
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    return o;
}

void GBufferFarg(
    v2f i,
    out float4 GT0 : SV_Target0,
    out float4 GT1 : SV_Target1,
    out float4 GT2 : SV_Target2,
    out float4 GT3 : SV_Target3)
{
    float3 color = tex2D(_MainTex, i.uv).rgb;
    float3 normal = i.normal;

    GT0 = float4(color, 1);
    GT1 = float4(normal * 0.5 + 0.5, 0);
    GT2 = float4(1, 1, 0, 1);
    GT3 = float4(0, 0, 1, 1);
}

#endif
