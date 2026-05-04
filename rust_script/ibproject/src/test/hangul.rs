use std::ops::Add;
use godot::prelude::*;


#[derive(GodotClass)]
#[class(tool, base=RefCounted, no_init)]
pub struct Hangul
{
    naratmal: Naratmal
}



pub struct Naratmal
{
    sentence: String,
    current: i32,
}


#[godot_api]
impl Hangul
{
    #[func]
    fn make_naratmal(&mut self, _sentense: String)
    {
        if !_sentense.is_empty()
        {
            let mut naratmal = Naratmal {
                sentence: _sentense, current: 0
            };

            self.naratmal = naratmal;

        }

        
    }


    #[func]
    fn join_phonemes(chrs: PackedStringArray) -> String
    {
        if !chrs.is_empty() && chrs.len() < 4
        {
            let mut chr_arr: [char; 3] = [' ', ' ', ' '];
            for i in 0..chrs.len()
            {
                if !chrs[i].is_empty()
                {
                    chr_arr[i] = *(chrs[i].chars().iter().nth(0).unwrap());
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
    fn split_phonemes(word: GString) -> PackedStringArray
    {
        let mut result: PackedStringArray = PackedStringArray::new();

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