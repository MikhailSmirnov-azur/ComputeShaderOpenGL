Shader "Hidden/BlitPositionsToTexture"
{
    Properties
    {

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.5

            #include "UnityCG.cginc"

            StructuredBuffer<float3> Positions;
            float _TexWidth;

            struct v2f
            {
                float4 pos : SV_Position;
                float2 uv  : TEXCOORD0;
            };

            v2f vert(appdata_img v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                int index = clamp(int(i.uv.x * _TexWidth), 0, _TexWidth - 1);

                float3 pos = Positions[index];
                return float4(pos, 0.0);
            }
            ENDCG
        }
    }
    FallBack Off
}
