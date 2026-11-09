using Godot;


[Tool]
public partial class MusicSpeaker : AudioStreamPlayer2D
{

    public MusicSpeaker()
    {
        Bus = "SFX";
        Autoplay = true;
    }

    public override void _EnterTree()
    {
        base._EnterTree();

    }

	
}
