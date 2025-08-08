Shader "Unlit/UnlitForCompute"
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
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_Position;
                float3 normal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
			};

            StructuredBuffer<float3> _Positions;

            fixed4 _BaseColor;

            v2f vert(appdata_base v, uint instanceID : SV_InstanceID)
            {
                v2f o;
                float4 wpos = mul(unity_ObjectToWorld, v.vertex + float4(_Positions[instanceID].xyz, 0));
                o.worldPos = wpos;
                o.pos = mul(UNITY_MATRIX_VP, wpos);
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldNormal = mul(unity_ObjectToWorld, i.normal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float lambertLight = max(0.5, dot(worldNormal, lightDir));

                float4 color = float4(lambertLight,lambertLight,lambertLight,1);
                return color*_BaseColor*max(saturate(i.worldPos.y),0.5);
            }
            ENDCG
        }
    }
}
