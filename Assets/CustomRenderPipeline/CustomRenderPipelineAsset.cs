    using UnityEngine;
    using UnityEngine.Rendering;
    [CreateAssetMenu(menuName = "Render/CustomRenderPipelineAsset")]
    public class CustomRenderPipelineAsset:RenderPipelineAsset
    {
        protected override RenderPipeline CreatePipeline()
        {
            return new CustomRenderPipeline(this); 
        }
    }
