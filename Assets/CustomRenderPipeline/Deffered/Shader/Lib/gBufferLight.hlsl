#ifndef  _GBUFFER_LIGHTING
#define _GBUFFER_LIGHTING
#include <HLSLSupport.cginc>
#include "Util/Constant.hlsl"
#include "./data.hlsl"


struct i2v
{
    float4 vertex:POSITION;
    float2 uv:TEXCOORD;
};

struct v2f
{
    float4 vertex:POSITION;
    float2 uv:TEXCOORD;
};


v2f vert(i2v i)
{
    v2f o = (v2f)0;
    o.uv = i.uv;
    o.uv.y = 1 - i.uv.y;
    o.vertex = i.vertex;

    #if defined (SHADER_TARGET_GLSL)
    o.vertex.z = -1;
    #else
    o.vertex.z = 0;
    #endif

    return o;
}

struct GBufferData
{
    float Depth;
    half3 Emission;
    half3 Albedo;
    half2 Rouglness;
    half AO;
    half Metalness;
    float3 NormalWs;
};

struct PosData
{
    float4 PositionWs;
    float3 ViewDir;
    float3 NormalWs;
};

PosData InitBrdfData(float2 uv, float depth, float3 normalWs)
{
    PosData posdata = (PosData)0;
    float4 ndc = float4(uv * 2 - 1, depth, 1);
    float4 worldPos = mul(_vpMatrixInv, ndc);
    worldPos /= worldPos.w;
    posdata.PositionWs = worldPos;
    posdata.NormalWs = normalize(normalWs);
    posdata.ViewDir = normalize((worldPos - _WorldSpaceCameraPos).rgb);
    return posdata;
}

GBufferData DecodeGBufferData(float2 uv)
{
    GBufferData gbufferData = (GBufferData)0;
    float depth = TEX_GBUFFER_DEPTH(uv);
    half3 albedo = TEX_GBUFFER_ALBEDO(uv);
    half3 normal = TEX_GBUFFER_NORMAL(uv).rgb;
    half4 emission_ao = TEX_GBUFFER_EMISSION_AO(uv);
    half2 rouglness_metal = TEX_GBUFFER_XX_ROUGLNESS_METAL(uv).ba;
    gbufferData.Depth = depth;
    gbufferData.Emission = emission_ao.rgb;
    gbufferData.Albedo = albedo.rgb;
    gbufferData.Rouglness.r = rouglness_metal.r;
    gbufferData.Rouglness.g = rouglness_metal.r * rouglness_metal.r;
    gbufferData.Metalness = rouglness_metal.g;
    gbufferData.AO.r = albedo;
    gbufferData.NormalWs = normal * 2 - 1;
    return gbufferData;
}

half4 farg(v2f i):SV_Target
{
    GBufferData gbuffer = DecodeGBufferData(i.uv);
    PosData pos = InitBrdfData(i.uv,gbuffer.Depth,gbuffer.NormalWs);
    return half4(pos.ViewDir, 1);
}


#endif
