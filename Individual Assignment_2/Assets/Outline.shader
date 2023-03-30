Shader "Custom/Outline"
{

    Properties
    {
        _MainTexture("Main Texture", 2D) = "white" {}
        _OutlineColor("Outline Color", Color) = (0,0,0,1)
        _Color("Color", Color) = (0,0,0,1)
        _Outline("Outline Width", Range(0, 100)) = 0.005
        _xVar("X variable", Range(0, 100)) = 0.005
        _yVar("Y variable", Range(0, 100)) = 0.005
        _outlineSpeed("Speed", Range(0, 100)) = 0.005
        _Amount("Extrusion Amount", Range(-10,10)) = 0.005
    }
        SubShader
        {
            CGPROGRAM
            #pragma surface surf Lambert vertex:vert

            #pragma target 3.0

            sampler2D _MainTexture;
            float4 _Color;
            float _Amount;

            struct Input
            {
                float2 uv_MainTexture;
            };

            struct appdata {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 texcoord: TEXCOORD0;
            };

            void vert(inout appdata v) {
                v.vertex.xyz += v.normal * _Amount * _Time.y;
            }


            void surf(Input IN, inout SurfaceOutput o)
            {
                half4 c = tex2D(_MainTexture, IN.uv_MainTexture);
                o.Albedo = c.rgb * _Color;
                o.Alpha = c.a;

                o.Albedo = tex2D(_MainTexture, IN.uv_MainTexture).rgb;

            }
            ENDCG

            Pass
            {
                Cull Front

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                struct appdata {

                    float4 vertex : POSITION;
                    float3 normal : NORMAL;

                };

                struct v2f {

                    float4 pos : SV_POSITION;
                    float4 color : COLOR;

                };

                float _Outline;
                float4 _OutlineColor;
                float _xVar;
                float _yVar;
                float _outlineSpeed;

                v2f vert(appdata v)
                {

                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);

                    float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
                    float2 offset = TransformViewToProjection(norm.xy);

                    offset *= sin(o.pos.x * _xVar + o.pos.y * _yVar + _Time.y * _outlineSpeed);

                    o.pos.xy += offset * o.pos.z * _Outline;
                    o.color = _OutlineColor;
                    return o;

                }

                float4 frag(v2f i) : SV_Target
                {
                    return i.color;

                }
                ENDCG


            }
        }
            FallBack "Diffuse"
}