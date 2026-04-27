use godot::{classes::{CanvasLayer, ICanvasLayer, RenderingServer}, prelude::*};

struct Tile
{
    cid: Rid,
    pos: Vector2i,
}


impl Tile
{
    fn create(_pos: Vector2i) -> Self
    {
        Self {
            cid: RenderingServer::singleton().canvas_item_create(),
            pos: _pos,
        }
    }
}

#[derive(GodotClass)]
#[class(init, base=CanvasLayer)]
struct TrainingMap
{
    #[init(val=Rid::Invalid)]
    canvas_item: Rid,
    #[init(val=Vector2i{x:640, y:360})]
    map_size: Vector2i,
    #[init(val=Vector2i{x:16, y:16})]
    tile_size: Vector2i,

    tiles: Vec<Tile>,

    base: Base<CanvasLayer>,
}


#[godot_api]
impl ICanvasLayer for TrainingMap
{
    fn enter_tree(&mut self)
    {
        let mut rs = RenderingServer::singleton();
        let canvas = self.to_gd().get_canvas();

        self.canvas_item = rs.canvas_item_create();
        rs.canvas_item_set_parent(self.canvas_item, canvas);

    }
}

#[godot_api]
impl TrainingMap
{
    fn create(&mut self)
    {

    }
}
