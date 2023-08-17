void K4aVertex_float(
    float2 uv,
    Texture2D positionMap,
    out float3 outPosition,
    out float3 outNormal,
    out float3 outTangent
)
{
    uint tw, th;
    positionMap.GetDimensions(tw, th);

    int tx = uv.x * tw;
    int ty = uv.y * th;

    float4 p = positionMap.Load(int3(tx, ty, 0));
    float3 p_x0 = positionMap.Load(int3(tx - 4, ty, 0)).xyz;
    float3 p_x1 = positionMap.Load(int3(tx + 4, ty, 0)).xyz;
    float3 p_y0 = positionMap.Load(int3(tx, ty - 4, 0)).xyz;
    float3 p_y1 = positionMap.Load(int3(tx, ty + 4, 0)).xyz;

    outPosition = p.xyz;
    outNormal = -normalize(cross(p_x1 - p_x0, p_y1 - p_y0));
    outTangent = lerp(float3(1, 0, 0), float3(0, 1, 0), p.w);
    
    float myNaN = 0.0f / 0.0f;
    if (p.w < 0.9999999)
    {
        //outPosition = float4(1e300f, 1e300f, 1e300f, 1e300f);
        outPosition = float4(myNaN, myNaN, myNaN, myNaN);
    }
}

void K4aColor_float(
    float2 uv,
    float3 tangent,
    float3 normal,
    Texture2D colorMap,
    float2 discardValues,
    float3 vertexPos,
    out float3 outColor,
    out float outAlpha
)
{ 
    uint tw, th;
    colorMap.GetDimensions(tw, th);

    int tx = uv.x * tw;
    int ty = uv.y * th;

    float4 c = colorMap.Load(int3(tx, ty, 0));

    outColor = c.rgb;
    outAlpha = 1;
    //outAlpha = smoothstep(0.99, 0.9999, tangent.y);
    
    //clip(tangent.y - 0.9999999); // ok = 0.9999999
    //if ((vertexPos.z > 10) || (vertexPos.z < 0.1))
    //{
    //    clip(-1);
    //}
    
    //if (tangent.y < 0.9999999)
    //{
    //    clip(tangent.y - 1);
    //}

    //float dotPr = dot(normal, vertexPos);
    ////outColor = float3(0.1, 1, -0.1) * dotPr;
    //outColor = normal;
    //if ((discardValues.x < dotPr) && (dotPr < discardValues.y))
    //{
    //    clip(-1);
    //}
}
