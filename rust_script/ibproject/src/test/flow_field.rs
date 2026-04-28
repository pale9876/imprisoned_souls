use std::{collections::HashMap};
use godot::{obj::NewAlloc, prelude::*};
use oauth2::reqwest::tls;


#[derive(GodotClass)]
#[class(init, base=RefCounted)]
struct FlowField
{
    region: HashMap<Vector2i, Cell>,
}

#[derive(Debug)]
struct Cell
{
    height: f32,
    // direction: Vector2,
}


impl Default for Cell
{
    fn default() -> Self {
        Self {
            height: 0.,
            // direction: Vector2::ZERO
        }
    }
}


#[godot_api]
impl FlowField
{
    #[func]
    fn create(&mut self, size: Vector2i)
    {
        for y in 0..size.x
        {
            for x in 0..size.y
            {
                self.region.insert(Vector2i { x: x, y: y }, Cell::default());
            }
        }
    }


    #[func]
    fn set_cell_height(&mut self, cell: Vector2i, height: f32)
    {
        if self.region.contains_key(&cell)
        {
            self.region.get_mut(&cell).unwrap().height = height;
        }
    }


    #[func]
    fn get_cell(&mut self, point: Vector2i) -> Dictionary<GString, Variant>
    {
        let mut result = Dictionary::new();
        let cell = self.region.get(&point).unwrap();

        result.set("height", cell.height);
        // result.set("direction", cell.direction);

        result
    }


    #[func]
    fn get_low(&mut self, point: Vector2i)
    {
        let mut neighbors = self.get_neighbors(point);
        neighbors.sort_by(
            |a, b|
                a.1.height.total_cmp(&b.1.height)
        );

        godot_print!("{:?}", neighbors[0]);
    }

    fn get_neighbors(&self, point: Vector2i) -> [(Vector2i, &Cell); 8]
    {
        
        let tl = Vector2i{x: point.x - 1, y: point.y - 1};
        let t= Vector2i{x: point.x, y: point.y - 1};
        let tr = Vector2i{x: point.x + 1, y: point.y - 1};
        let r = Vector2i{x: point.x + 1, y: point.y};
        let br = Vector2i{x: point.x + 1, y: point.y + 1};
        let b = Vector2i{x: point.x, y: point.y + 1};
        let bl = Vector2i{x: point.x - 1, y: point.y + 1};
        let l = Vector2i{x: point.x - 1, y: point.y};

        let top_left = self.region.get(&tl).unwrap();
        let top = self.region.get(&t).unwrap();
        let top_right = self.region.get(&tr).unwrap();
        let right = self.region.get(&r).unwrap();
        let bottom_right = self.region.get(&br).unwrap();
        let bottom = self.region.get(&b).unwrap();
        let bottom_left = self.region.get(&bl).unwrap();
        let left = self.region.get(&l).unwrap();

        let result = [
            (tl, top_left), (t, top), (tr, top_right),
            (r, right), (br, bottom_right), (b, bottom), (bl, bottom_left), (l, left)
        ];

        result
    }

}

