using UnityEngine;
using UnityEngine.Rendering;

public abstract class ScriptablePass
{
    // public abstract void OnCameraSetup(Camera camera);
    // public abstract void OnCameraRenderFinish();
    public abstract void BeforeRender();
    public abstract void AfterRender();
    public abstract void Execute(ScriptableRenderContext context, ref RenderingData renderingData);
}