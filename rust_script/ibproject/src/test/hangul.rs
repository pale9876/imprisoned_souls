use std::ops::Add;

use godot::prelude::*;
use tossicat::*;

#[derive(GodotClass)]
#[class(tool, base=RefCounted, no_init)]
pub struct Hangul
{
    
}

#[godot_api]
impl Hangul
{
    #[func]
    fn tf(word: GString, tossi:GString) -> String
    {
        let _word = word.clone().to_string();
        let _tossi = tossi.clone().to_string();

        if let Ok(result)= transform(&_word, &_tossi)
        {
            return result.0.add(&result.1)
        }

        return String::default()
    }
}