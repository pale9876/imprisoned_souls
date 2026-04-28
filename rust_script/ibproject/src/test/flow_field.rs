use std::{collections::HashMap};
use godot::prelude::*;


#[derive(GodotClass)]
#[class(init, base=RefCounted)]
struct FlowField
{
    region: HashMap<Vector2i, Cell>,
}


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
        let neighbors = self.get_neighbors(point);

        
    }

    fn get_neighbors(&self, point: Vector2i) -> [&Cell; 8]
    {
        let top_left = self.region.get(&Vector2i{x: point.x - 1, y: point.y - 1}).unwrap();
        let top = self.region.get(&Vector2i{x: point.x, y: point.y - 1}).unwrap();
        let top_right = self.region.get(&Vector2i{x: point.x + 1, y: point.y - 1}).unwrap();
        let right = self.region.get(&Vector2i{x: point.x + 1, y: point.y}).unwrap();
        let bottom_right = self.region.get(&Vector2i{x: point.x + 1, y: point.y + 1}).unwrap();
        let bottom = self.region.get(&Vector2i{x: point.x, y: point.y + 1}).unwrap();
        let bottom_left = self.region.get(&Vector2i{x: point.x - 1, y: point.y + 1}).unwrap();
        let left = self.region.get(&Vector2i{x: point.x - 1, y: point.y}).unwrap();

        return [top_left, top, top_right, right, bottom_right, bottom, bottom_left, left]
    }

}

