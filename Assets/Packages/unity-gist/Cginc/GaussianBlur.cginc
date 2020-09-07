#ifndef GAUSSIANBLUR 
#define GAUSSIANBLUR 
#include "ConstantUtil.cginc"

sampler2D _BlurTex;
float4 DirectionalGaussianBlur(int samples, float2 dir, float SD, float blurSize, float aspct, float2 i_uv)
{
    float invSamples = 1.0 / (samples - 1);
    float dispersion = SD * SD;
    float sum;
    float4 col;
    for (int i = 0; i < samples; i++)
    {
        float offset = (i * invSamples - 0.5) * blurSize * aspct;
        float2 uv = i_uv + dir * offset;
        float gauss = pow(E, -pow(offset, 2) / (2 * dispersion)) / sqrt(PI2 * dispersion);
        sum += gauss;
        col += tex2D(_BlurTex, uv) * gauss;
    }
    col /= sum;
    return col;
}

#endif