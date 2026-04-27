extern crate proc_macro;
extern crate endeka_renderer;

use godot::prelude::*;
use proc_macro::TokenStream;


use endeka_renderer::IntoStringHashMap;

struct IBProject;

mod test;


// #[derive(IntoStringHashMap)]
// pub struct User {
//     username: String,
//     first_name: String,
//     last_name: String,
//     age: u32,
// }



#[gdextension]
unsafe impl ExtensionLibrary for IBProject {
    
}





pub mod rendering_help{
    macro_rules! create_cid {
        ($x: ident) => {
            $x.cid = RenderingServer::singleton().canvas_item_create();
        };
    }
    
    macro_rules! cid_parent {
        ($x:ident) => {
            RenderingServer::singleton().canvas_item_set_parent($x.cid, get_canvas!($x));
        };
    }
    
    
    macro_rules! renserver_free_rid {
        ($x: ident) => {
            RenderingServer::singleton().free_rid(get_cid!($x));
        };
    }



}
