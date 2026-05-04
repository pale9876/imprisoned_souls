use godot::{
    classes::{CanvasLayer, ICanvasLayer,RenderingServer},
    prelude::*,
};

use endeka::*;


#[derive(GodotClass, Endeka)]
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


#[derive(EEAD, GodotClass)]
#[class(base=Node, init, tool)]
struct REEAD
{
    base: Base<Node>,
}

