Shader "Unlit/LightPass"
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
                "LightMode"="LightPass"
            }
            Cull Off ZWrite Off ZTest Always
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment farg
            
            #include "./Lib/gBufferLight.hlsl"




            ENDCG
        }
    }
}