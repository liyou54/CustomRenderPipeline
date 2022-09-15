using UnityEngine;
using UnityEngine.Rendering;

public class SkyBoxPass:ScriptablePass
{

    
    public override void BeforeRender()
    {

    }

    public override void AfterRender()
    {
    }

    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        CommandBuffer cmd = CommandBufferPool.Get();
        context.DrawSkybox(renderingData.CameraData);
        context.ExecuteCommandBuffer(cmd);
        cmd.Release();
    }
} 
