#include <UnityShaderVariables.cginc>
#ifndef BRDF_HLSL
#define BRDF_HLSL
#include "./Util/Constant.hlsl"
#include "./data.hlsl"

// D
float Trowbridge_Reitz_GGX(float NdotH, float a)
{
    float a2 = a * a;
    float NdotH2 = NdotH * NdotH;

    float nom = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;

    return nom / denom;
}

// F
float3 SchlickFresnel(float HdotV, float3 F0)
{
    float m = clamp(1 - HdotV, 0, 1);
    float m2 = m * m;
    float m5 = m2 * m2 * m; // pow(m,5)
    return F0 + (1.0 - F0) * m5;
}

// G
float SchlickGGX(float NdotV, float k)
{
    float nom = NdotV;
    float denom = NdotV * (1.0 - k) + k;

    return nom / denom;
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
    float3 LightDir;
    float3 NormalWs;
};

PosData InitPosData(float2 uv, float depth, float3 normalWs)
{
    PosData posdata = (PosData)0;
    float4 ndc = float4(uv * 2 - 1, depth, 1);
    float4 worldPos = mul(_vpMatrixInv, ndc);
    worldPos /= worldPos.w;
    posdata.PositionWs = worldPos;
    posdata.NormalWs = normalize(normalWs);
    posdata.ViewDir = normalize((worldPos - _WorldSpaceCameraPos).rgb);
    posdata.LightDir = normalize(_VisitableLightDirect[0]);
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

// 直接光照
float3 PBR(in PosData pos, in GBufferData gbuffer, float3 radiance)
{
    half  roughness = max(gbuffer.Rouglness.r, 0.05); // 保证光滑物体也有高光

    float3 H = normalize(pos.LightDir + pos.ViewDir);
    float NdotL = max(dot(pos.NormalWs, pos.LightDir), 0);
    float NdotV = max(dot(pos.NormalWs, pos.ViewDir), 0);
    float NdotH = max(dot(pos.NormalWs, H), 0);
    float HdotV = max(dot(H, pos.ViewDir), 0);
    float alpha = roughness * roughness;
    float k = ((alpha + 1) * (alpha + 1)) / 8.0;
    float3 F0 = lerp(float3(0.04, 0.04, 0.04), gbuffer.Albedo, gbuffer.Metalness);

    float D = Trowbridge_Reitz_GGX(NdotH, alpha);
    float3 F = SchlickFresnel(HdotV, F0);
    float G = SchlickGGX(NdotV, k) * SchlickGGX(NdotL, k);

    float3 k_s = F;
    float3 k_d = (1.0 - k_s) * (1.0 -  gbuffer.Metalness);
    float3 f_diffuse = gbuffer.Albedo / PI;
    float3 f_specular = (D * F * G) / (4.0 * NdotV * NdotL + 0.0001);
    f_diffuse *= PI;
    f_specular *= PI;
    float3 color = (k_d * f_diffuse + f_specular) * radiance * NdotL;

    return color;
}

#endif
