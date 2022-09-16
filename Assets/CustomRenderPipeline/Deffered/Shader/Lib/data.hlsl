#ifndef _GBUFFER_DATA_HLSL
#define _GBUFFER_DATA_HLSL

#include <HLSLSupport.cginc>
#define MAX_LIGGHT_COUNT 16
#define TEX_GBUFFER_DEPTH(uv) (tex2D(_GDepth,(uv)).r)
#define TEX_GBUFFER_NORMAL(uv) (tex2D(_GT1,(uv)))
#define TEX_GBUFFER_ALBEDO(uv) (tex2D(_GT0,(uv)))
#define TEX_GBUFFER_XX_ROUGLNESS_METAL(uv) (tex2D(_GT2,(uv)))
#define TEX_GBUFFER_EMISSION_AO(uv) (tex2D(_GT3,(uv)))
sampler2D _GDepth;
sampler2D _GT0;
sampler2D _GT1;
sampler2D _GT2;
sampler2D _GT3;

CBUFFER_START(_LightBuffer)
uint _NowLightCount;
float4 _VisitableLightColor[MAX_LIGGHT_COUNT];
float4 _VisitableLightDirect[MAX_LIGGHT_COUNT];
float4x4 _vpMatrix;
float4x4 _vpMatrixInv;
CBUFFER_END

#endif
