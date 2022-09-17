public class DefferedRenderer : ScriptableRenderer
{
    public GBufferPass gbufferPass;
    public SkyBoxPass SkyBoxPass;
    public LightPass LightPass;

    public override void Init()
    {
        gbufferPass = new GBufferPass();
        SkyBoxPass = new SkyBoxPass();
        LightPass = new LightPass();
        AddPass(gbufferPass);
        AddPass(LightPass);
        AddPass(SkyBoxPass);
    }
}