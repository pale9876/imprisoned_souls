use std::ops::Add;
use godot::prelude::*;


#[derive(GodotClass)]
#[class(tool, base=RefCounted, no_init)]
pub struct Hangul
{
    
}

#[godot_api]
impl Hangul
{

    #[func]
    fn join_phonemes(chrs: Array<GString>) -> String
    {
        if !chrs.is_empty() && chrs.len() < 4
        {
            let mut chr_arr: [char; 3] = [' ', ' ', ' '];
            for i in 0..chrs.len()
            {
                if !chrs.at(i).is_empty()
                {
                    chr_arr[i] = *(chrs.at(i).chars().iter().nth(0).unwrap());
                }
            }
            
            return tossicat::join_phonemes(chr_arr).to_string()
        }

        String::default()
    }

    #[func]
    fn transform(word: GString, tossi:GString) -> String
    {
        let _word = word.clone().to_string();
        let _tossi = tossi.clone().to_string();

        if let Ok(result)= tossicat::transform(&_word, &_tossi)
        {
            return result.0.add(&result.1)
        }

        return String::default()
    }

    #[func]
    fn split_phonemes(word: GString) -> Array<GString>
    {
        let mut result: Array<GString> = Array::new();

        for i in 0..word.len()
        {
            let chr = word.chars().iter().nth(i).unwrap();
            if let Ok(chr_arr) = tossicat::split_phonemes(*chr)
            {
                for j in chr_arr
                {
                    if !j.eq(&' ')
                    {
                        let str = j.to_string();
                        result.push(&str);
                    }
                }
            }
        }

        result

    }


    #[func]
    fn modify_sentence(sentence: GString) -> String
    {
        if let Ok(_sentense) = tossicat::modify_sentence(&(String::from(&sentence)))
        {
            return _sentense
        }

        String::default()
    }

}