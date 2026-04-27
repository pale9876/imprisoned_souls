extern crate proc_macro;

use godot::prelude::*;
use proc_macro::TokenStream;

struct IBProject;


mod test;


#[gdextension]
unsafe impl ExtensionLibrary for IBProject {

}