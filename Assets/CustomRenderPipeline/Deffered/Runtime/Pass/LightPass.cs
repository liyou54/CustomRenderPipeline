using UnityEngine;
using UnityEngine.Rendering;

public class LightPass : ScriptablePass
{
    private Mesh mesh;
    private Material material;
    private const int MAX_LIGHT_COUNT = 16;
    
    ShaderTagId shaderTagId = new ShaderTagId("LightPass");
    private static int _VisitableLightColorId = Shader.PropertyToID("_VisitableLightColor");
    private static int _VisitableLightDirectId = Shader.PropertyToID("_VisitableLightDirect");
    Vector4[] VisitableLightColor = new Vector4[MAX_LIGHT_COUNT];
    Vector4[] VisitableLightDirect = new Vector4[MAX_LIGHT_COUNT];

    private void InitMesh()
    {
        mesh = new Mesh();
        mesh.vertices = new Vector3[]
        {
            // 这里的第三个z分量最好不要在这里设置，最好在shader中判断是GL还是DX平台来设置为近截面的z值就好
            new Vector3(-1, 1, 0), // bl
            new Vector3(-1, -1, 0), // tl
            new Vector3(1, -1, 0), // tr
            new Vector3(1, 1, 0), // br
        };
        mesh.uv = new Vector2[]
        {
            new Vector2(0, 0), // bl
            new Vector2(0, 1), // tl
            new Vector2(1, 1), // tr
            new Vector2(1, 0), // br
        };
        mesh.triangles = new int[]
        {
            0, 1, 2,
            0, 2, 3
        };
    }

    public override void BeforeRender()
    {
        if (mesh == null)
        {
            InitMesh();
        }

        if (material == null)
        {
            var shader = Shader.Find("Unlit/LightPass");
            material = new Material(shader);
        }
    }


    public override void AfterRender()
    {
    }

    void GetLightData()
    {
        
    }
    
    public void SetLightData()
    {
    }
    
    public override void Execute(ScriptableRenderContext context,ref RenderingData renderingData)
    {
        CommandBuffer cmd = CommandBufferPool.Get();
        cmd.name = "LightPass";
        cmd.SetRenderTarget(BuiltinRenderTextureType.CameraTarget);

        cmd.DrawMesh(mesh, Matrix4x4.identity, material);
        context.ExecuteCommandBuffer(cmd);
        cmd.Release();
    }
}