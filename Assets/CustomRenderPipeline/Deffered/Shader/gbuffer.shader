Shader "Unlit/gbuffer"
{
    Properties
    {
        _MainTex ("_MainTex", 2D) = "white" {}
        _NormalTex ("_NormalTex", 2D) = "bump" {}
        _RoughnessTex ("_RoughnessTex", 2D) = "white" {}
        _MetalTex ("_MetalTex", 2D) = "white" {}
         _OcclusionTex ("Occlusion Map", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }

        Pass
        {
            Tags
            {
                "LightMode"="gbuffer"
            }
            CGPROGRAM
            #include "./Lib/gbuffer.hlsl"
            #pragma vertex GBufferVert
            #pragma fragment GBufferFarg
            ENDCG
        }

    }
}