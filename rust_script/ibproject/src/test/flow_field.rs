use std::collections::{HashMap};
use godot::{prelude::*};


#[derive(GodotClass)]
#[class(init, base=RefCounted)]
struct DetourField
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
impl DetourField
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


    fn get_neighbors()
    {

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


}

