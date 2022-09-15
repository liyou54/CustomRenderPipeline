Shader "Unlit/gbuffer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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