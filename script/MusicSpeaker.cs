using Godot;



[Tool]
public partial class MusicSpeaker : AudioStreamPlayer2D
{

    public MusicSpeaker()
    {
        Bus = "SFX";
        
        if (!Engine.IsEditorHint())
        {
            Autoplay = true;
            Playing = true;
            
        }
    }

	
}
