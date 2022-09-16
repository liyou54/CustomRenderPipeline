#ifndef _GBUFFER_HLSL
#define _GBUFFER_HLSL
#include "UnityCG.cginc"
#include "./data.hlsl"
struct appdata
{
    float4 vertex : POSITION;
    float4 normal : NORMAL;
    float4 tangent : TANGENT;
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 normal : NORMAL;
    float4 vertex : SV_POSITION;
    float4 tangent : TEXCOORD1;
    float4 bittangent : TEXCOORD2;
};



CBUFFER_START(UnityPerMaterial)
float4 _MainTex_ST;
CBUFFER_END

sampler2D _MainTex;
sampler2D _NormalTex;
sampler2D _RoughnessTex;
sampler2D _MetalTex;
sampler2D _OcclusionTex;
v2f GBufferVert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
    o.tangent =float4( v.tangent.xyz,1);
    o.bittangent =float4( binormal.xyz,1);
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
    float rouglness = tex2D(_RoughnessTex, i.uv).r;
    float metal = tex2D(_MetalTex, i.uv).r;
    float ao = tex2D(_OcclusionTex, i.uv).r;
    float3 normalMap = UnpackNormal(tex2D(_NormalTex, i.uv));
    float3 normal = mul(normalMap,float3x3(i.tangent.xyz,i.bittangent.xyz,i.normal.xyz));
    
    normal.xy = normal.xy * 1;
    GT0 = float4(color, 1);
    GT1 = float4(normal, 0);
    GT2 = float4(0,0,rouglness, metal);
    GT3 = float4(0,0,0, ao);
}

#endif
