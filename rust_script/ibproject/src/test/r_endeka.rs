use godot::{
    classes::{CanvasLayer, RenderingServer},
    prelude::*,
};

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

pub struct REEAD {}

#[godot_api]
impl REndeka {
    fn create(&mut self) {
        // self.cid = !();
    }
}
