// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Shader_Billboard"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparant" "Queue"="Transparent+500" } //As I use an image of a pengiun with a tranparant background rendertype is set accordingly.
        LOD 100

        Pass
        {
            ZTest Off //Rendered no matter what, treated as sort of a UI element.
            Blend SrcAlpha OneMinusSrcAlpha //Set blend mode to a standard alpha blend.
            Cull Off //In case I flip the normals instead of seeing nothing I will still be able to see the shader.

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;

                float4 world_origin = mul(UNITY_MATRIX_M, float4(0,0,0,1)); //Where is our object in world space
                float4 view_origin = float4(UnityObjectToViewPos(float3(0,0,0)), 1);

                float4 world_pos = mul(UNITY_MATRIX_M, v.vertex); //Split the matrix calculations out into three float4s. This slows down the shader, but in this case it is okay
                float4 flipped_world_pos = float4(-1,1,-1,1) * (world_pos - world_origin) + world_origin; //Flipping the x-axis and the z-axis rotating it effectively 180 degress. world_origin is subtracted and then added to fix wonky behavior as origin of geometry also was flipped

                float4 view_pos = flipped_world_pos - world_origin + view_origin;


                float4 clip_pos = mul(UNITY_MATRIX_P, view_pos);

                o.vertex = clip_pos;

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
