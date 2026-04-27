use godot::{
    classes::{CanvasLayer, RenderingServer},
    prelude::*,
};

use endeka::EndekaEEAD;


#[derive(GodotClass)]
#[class(base=CanvasLayer, init, tool)]
pub struct REndeka {
    #[init(val=Rid::Invalid)]
    cid: Rid,

    #[init(val = false)]
    init: bool,

    #[export_tool_button(fn = Self::create, name = "Create", icon = "2D")]
    _create: PhantomVar<Callable>,

    base: Base<CanvasLayer>,
}



#[godot_api]
impl REndeka {
    fn create(&mut self) {
        // self.cid = !();
    }
}

#[derive(EndekaEEAD)]
struct REEAD
{

}

