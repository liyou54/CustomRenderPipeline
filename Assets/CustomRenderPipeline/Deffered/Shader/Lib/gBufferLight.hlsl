#ifndef  _GBUFFER_LIGHTING
#define _GBUFFER_LIGHTING
#include <HLSLSupport.cginc>
#include "Util/Constant.hlsl"
#include "./data.hlsl"
#include "brdf.hlsl"

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


half4 farg(v2f i):SV_Target
{
    
    GBufferData gbuffer = DecodeGBufferData(i.uv);
    PosData pos = InitPosData(i.uv,gbuffer.Depth,gbuffer.NormalWs);
    float3 radiance = _VisitableLightColor[0].rgb;
    float3 color = PBR(pos, gbuffer, radiance);
    return half4(color, 1);
}


#endif
