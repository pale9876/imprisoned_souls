use std::collections::{HashMap};
use godot::{prelude::*};


#[derive(GodotClass)]
#[class(init, base=RefCounted)]
struct RDetourField
{
    rect: Rect2i,
    region: HashMap<(i32, i32), Cell>,
}


#[derive(Debug)]
struct Cell
{
    height: f32, // 높이 값이 1.0이면 막힌 벽이고 0이면
    direction: Vector2,
}


impl Default for Cell
{
    fn default() -> Self {
        Self {
            height: 0.,
            direction: Vector2::ZERO
        }
    }
}


#[godot_api]
impl RDetourField
{
    fn create(&mut self, rect: Rect2i)
    {
        self.rect = rect
    }

    fn has_point(&mut self, &point: Vector2i) -> bool
    {
        self.rect.contains_point(point)
    }

    fn get_height(&mut self, &point: Vector2i) -> f32
    {
        if self.has_point(point)
        {
            let tuple = (point.x, point.y);
            if self.region.contains_key(&tuple)
            {
                return self.region.get(&tuple).unwrap().height
            }
        }
        
        0.
    }


    fn get_neighbors(&mut self, &point: Vector2i)
    {
        let top_left = Self::TL(point);
        
    }


    fn set_point_height(&mut self, &point: Vector2i, &height: f32)
    {

    }


    fn make_circle_obstacle(&mut self, &point: Vector2i, &radius: i32)
    {

    }


    fn make_rect_obstacle(&mut self, rect: Rect2i)
    {

    }



    fn make_slope()
    {

    }
    
    const TL: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x - 1, y: a.y - 1} };
    const T: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x, y: a.y - 1} };
    const TR: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x + 1, y: a.y - 1} };
    const L: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x - 1, y: a.y} };
    const R: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x + 1, y: a.y} };
    const BL: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x - 1, y: a.y + 1} };
    const B: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x, y: a.y + 1} };
    const BR: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x + 1, y: a.y + 1} };

}

