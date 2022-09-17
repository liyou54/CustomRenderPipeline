using UnityEngine;
using UnityEngine.Rendering;

public class CustomRenderPipeline : RenderPipeline
{
    private CustomRenderPipelineAsset RenderPipelineAsset;
    private ScriptableRenderer ScriptableRendererAsset;


    public CustomRenderPipeline(CustomRenderPipelineAsset customRenderPipelineAsset)
    {
        RenderPipelineAsset = customRenderPipelineAsset;
        ScriptableRendererAsset = new DefferedRenderer();
        ScriptableRendererAsset.Init();
    }

    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        GraphicsSettings.useScriptableRenderPipelineBatching = true;
        foreach (Camera camera in cameras)
        {
            if (camera.tag == "MainCamera")
            {
                camera.depthTextureMode |= DepthTextureMode.Depth;
                continue;
            }
        }

        foreach (var renderPass in ScriptableRendererAsset.RenderPass)
        {
            renderPass.BeforeRender();
        }

        foreach (Camera camera in cameras)
        {
            context.SetupCameraProperties(camera);
            camera.TryGetCullingParameters(out var parameters);
            var results = context.Cull(ref parameters);

            RenderingData renderingData = new RenderingData() {CullResults = results, CameraData = camera};
            foreach (var renderPass in ScriptableRendererAsset.RenderPass)
            {
                renderPass.Execute(context, ref renderingData);
            }
        }

        context.Submit();
        foreach (var renderPass in ScriptableRendererAsset.RenderPass)
        {
            renderPass.AfterRender();
        }
    }
}

public class RenderingData
{
    public CullingResults CullResults;
    public Camera CameraData;
}