using System;
using System.Collections.Generic;
public abstract class ScriptableRenderer
{
    public abstract void Init();
    public List<ScriptablePass> RenderPass = new List<ScriptablePass>(32);

    public void AddPass(ScriptablePass pass)
    {
        RenderPass.Add(pass);
    }
 
}