use godot::{classes::AudioStream, prelude::*};
use rodio::{Player, mixer::Mixer};



#[derive(GodotClass)]
#[class(no_init, base=RefCounted)]
struct RodioPlayer
{
    // VAR
    #[var]
    stream: Gd<AudioStream>,

    // NON VAR
    player: rodio::Player,
    
    base: Base<RefCounted>
}


struct RadioSource
{
    
}


#[godot_api]
impl RodioPlayer
{
    #[func]
    fn is_playing(&mut self) -> bool { !self.player.is_paused() }


    #[func]
    fn play(&mut self)
    {

    }

    fn stop()
    {

    }
}
