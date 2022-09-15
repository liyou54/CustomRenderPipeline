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
            #include "./Lib/gbuffer.hlsl"

            struct i2v
            {
                float4 vertex:POSITION;
                float2 uv:TEXCOORD;
            };

            struct v2f1
            {
                float4 vertex:POSITION;
                float2 uv:TEXCOORD;
            };


            v2f1 vert(i2v i)
            {
                v2f1 o = (v2f1)0;
                o.uv = i.uv;
                o.uv.y =1- i.uv.y;
                o.vertex = i.vertex;

                #if defined (SHADER_TARGET_GLSL)
                  o.vertex.z = -1;
                #else
                o.vertex.z = 0;
                #endif

                return o;
            }

            half4 farg(v2f1 i):SV_Target
            {
                half4 res= tex2D(_GT1, i.uv.xy);
                return res;
            }
            ENDCG
        }
    }
}