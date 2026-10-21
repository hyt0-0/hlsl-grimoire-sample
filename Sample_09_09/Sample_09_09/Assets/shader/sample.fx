/*!
 * @brief チェッカーボードワイプ
 */

cbuffer cb : register(b0)
{
    float4x4 mvp;           // MVP行列
    float4 mulColor;        // 乗算カラー
};

cbuffer NagaCB : register( b1 )
{
    float negaRate; // ネガポジ反転率
    float wipeSize; 
};

struct VSInput
{
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

struct PSInput
{
    float4 pos : SV_POSITION;
    float2 uv  : TEXCOORD0;
};

Texture2D<float4> colorTexture : register(t0); // カラーテクスチャ
sampler Sampler : register(s0);

PSInput VSMain(VSInput In)
{
    PSInput psIn;
    psIn.pos = mul(mvp, In.pos);
    psIn.uv = In.uv;
    return psIn;
}

float4 PSMain(PSInput In) : SV_Target0
{
    float4 color = colorTexture.Sample(Sampler, In.uv);

    // step-1 画像を徐々にネガポジ反転させていく
    
    //課題:ネガポジ反転

    float3 negaColor;
    negaColor.x = 1.0f - color.x;
    negaColor.y = 1.0f - color.y;
    negaColor.z = 1.0f - color.z;

    color.xyz = lerp(color.xyz, negaColor, negaRate);
    
    ////課題:グレースケール
    //float Y = 0.299f * color.r + 0.587f * color.g + 0.114f * color.b;
    //float3 monochromeColor = float3(Y, Y, Y);
    //color.xyz = monochromeColor;
    
    ////課題:ワイプ
    //float t = (int) fmod(In.pos.x, 64.0f);
    //clip(t - wipeSize);

    return color;
}
