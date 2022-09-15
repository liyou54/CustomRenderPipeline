#ifndef  _GBUFFER_LIGHTING
#define _GBUFFER_LIGHTING
#include <HLSLSupport.cginc>
#define MAX_LIGGHT_COUNT 16
CBUFFER_START(_LightBuffer)
uint _NowLightCount;
float4 _VisitableLightColor[MAX_LIGGHT_COUNT];
float4 _VisitableLightDirect[MAX_LIGGHT_COUNT];
CBUFFER_END

#endif