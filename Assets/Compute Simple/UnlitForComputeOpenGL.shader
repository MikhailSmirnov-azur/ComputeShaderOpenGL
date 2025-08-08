Shader "Unlit/UnlitForComputeTex1D"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            Texture2D _PositionTex;

            float _TexWidth;
            fixed4 _BaseColor;

            struct v2f
            {
                float4 pos : SV_Position;
                float3 normal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 check : TEXCOORD2;
            };

            v2f vert(appdata_base v, uint instanceID : SV_InstanceID)
            {
                v2f o;

                int2 texCoord = int2(instanceID, 0); 
                float3 posOffset = _PositionTex.Load(int3(texCoord, 0)).xyz;

                float4 wpos = mul(unity_ObjectToWorld, v.vertex + float4(posOffset, 0));
                o.worldPos = wpos;
                o.pos = mul(UNITY_MATRIX_VP, wpos);
                o.normal = v.normal;
                //o.check = float3(instanceID, instanceID,instanceID);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, i.normal));
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float lambertLight = max(0.5, dot(worldNormal, lightDir));

                float4 color = float4(lambertLight, lambertLight, lambertLight, 1);
                //return float4(i.check.yyy/128,1);
                return color * _BaseColor * max(saturate(i.worldPos.y), 0.5);
            }
            ENDCG
        }
    }
}
