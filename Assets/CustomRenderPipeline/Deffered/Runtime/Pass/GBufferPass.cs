﻿using UnityEngine;
using UnityEngine.Rendering;

public class GBufferPass : ScriptablePass
{
    RenderTexture gdepth; // depth attachment
    RenderTexture[] gbuffers = new RenderTexture[4]; // color attachments 
    RenderTargetIdentifier[] gbufferID = new RenderTargetIdentifier[4];
    ShaderTagId shaderTagId = new ShaderTagId("gbuffer");
    bool isInit = false;

    public override void BeforeRender()
    {
        if (!isInit)
        {
            gdepth = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.Depth,
                RenderTextureReadWrite.Linear);
            gbuffers[0] = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGB32,
                RenderTextureReadWrite.Linear);
            gbuffers[1] = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGB2101010,
                RenderTextureReadWrite.Linear);
            gbuffers[2] = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGB64,
                RenderTextureReadWrite.Linear);
            gbuffers[3] = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGBFloat,
                RenderTextureReadWrite.Linear);
            for (int i = 0; i < 4; i++)
                gbufferID[i] = gbuffers[i];
            isInit = true;
        }


    }

    public void SetGbuffer()
    {
        
    }
    
    public override void AfterRender()
    {
        // if (gdepth.width != Screen.width || gdepth.height != Screen.height)
        // {
        //     gdepth.Release();
        //     for (int i = 0; i < 4; i++)
        //         gbuffers[i].Release();
        //     gdepth = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.Depth,
        //         RenderTextureReadWrite.Linear);
        //     gbuffers[0] = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGB32,
        //         RenderTextureReadWrite.Linear);
        //     gbuffers[1] = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGB2101010,
        //         RenderTextureReadWrite.Linear);
        //     gbuffers[2] = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGB64,
        //         RenderTextureReadWrite.Linear);
        //     gbuffers[3] = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGBFloat,
        //         RenderTextureReadWrite.Linear);
        // }
    }




    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        CommandBuffer cmd = CommandBufferPool.Get();
        cmd.ClearRenderTarget(true, true, Color.black);
        cmd.SetRenderTarget(gbufferID, gdepth);
        cmd.ClearRenderTarget(true, true, Color.black);
        cmd.name = "gbuffer";
        context.SetupCameraProperties(renderingData.CameraData);
        DrawingSettings ds = new DrawingSettings();
        ds.SetShaderPassName(0, shaderTagId);
        ds.sortingSettings = new SortingSettings() {criteria = SortingCriteria.CommonOpaque};
        FilteringSettings fs = new FilteringSettings(RenderQueueRange.opaque);
        cmd.SetGlobalTexture("_GDepth", gdepth);
        for(int i=0; i<4; i++) 
            cmd.SetGlobalTexture("_GT"+i, gbuffers[i]);
        context.ExecuteCommandBuffer(cmd);
        cmd.Release();
        context.DrawRenderers(renderingData.CullResults, ref ds, ref fs);
    }
}