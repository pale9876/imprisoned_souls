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
        self.rect = rect;
        
        if !self.region.is_empty()
        {
            self.region.clear();
        }
    }

    fn clear(&mut self)
    {
        self.region.clear();
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

    #[func]
    fn set_point_height(&mut self, &point: Vector2i, &height: f32)
    {
        if self.has_point(point)
        {
            let tuple = (point.x, point.y);
            if self.region.contains_key(&tuple)
            {
                let cell = self.region.get_mut(&tuple).unwrap();
                cell.height = height;
            }
            else
            {
                self.region.insert(
                    tuple, Cell{height: height, direction: Vector2::ZERO}
                );
            }
        }
    }

    #[func]
    fn get_obstacles(&mut self)
    {
        godot_print!("{:?}", self.region);
    }


    fn make_circle_obstacle(&mut self, &point: Vector2i, &radius: i32)
    {

    }

    #[func]
    fn set_point_direction(&mut self, &point: Vector2i, &value: Vector2)
    {
        if self.has_point(point)
        {
            let tuple = (point.x, point.y);
            if self.region.contains_key(&tuple)
            {
                let cell = self.region.get_mut(&tuple).unwrap();
                cell.direction = value;
            }
            else
            {
                self.region.insert(
                    tuple, Cell{height: 0., direction: value
                });
            }
        }
    }


    #[func]
    fn make_obstacle(&mut self, &rect: Rect2i)
    {
        let center_pos = Vector2{
            x: (rect.position.x as f32) + ((rect.size.x as f32) / 2.),
            y: (rect.position.y as f32) + (rect.size.y as f32) / 2.
        };

        for x in rect.position.x..rect.position.x + rect.size.x
        {
            for y in rect.position.y..rect.position.y + rect.size.y
            {
                let point = Vector2i { x: x, y: y };                
                self.set_point_height(point, 1.);
                self.set_point_direction(
                    point, Vector2{
                        x: if (x as f32) < center_pos.x {1.} else {- 1.},
                        y: if (y as f32) > center_pos.y {-1.} else {1.}
                    }
                );
            }
        }
    }


    const TL: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x - 1, y: a.y - 1} };
    const T: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x, y: a.y - 1} };
    const TR: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x + 1, y: a.y - 1} };
    const L: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x - 1, y: a.y} };
    const R: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x + 1, y: a.y} };
    const BL: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x - 1, y: a.y + 1} };
    const B: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x, y: a.y + 1} };
    const BR: fn(Vector2i) -> Vector2i = |a: Vector2i| { return Vector2i{x: a.x + 1, y: a.y + 1} };


    #[func] fn TOPLEFT(point: Vector2i) -> Vector2i{ Self::TL(point) }
    #[func] fn TOPRIGHT(point: Vector2i) -> Vector2i{ Self::T(point) }
    #[func] fn TOP(point: Vector2i) -> Vector2i{ Self::TR(point) }
    #[func] fn LEFT(point: Vector2i) -> Vector2i{ Self::L(point) }
    #[func] fn RIGHT(point: Vector2i) -> Vector2i{ Self::R(point) }
    #[func] fn BOTTOMLEFT(point: Vector2i) -> Vector2i{ Self::BL(point) }
    #[func] fn BOTTOM(point: Vector2i) -> Vector2i{ Self::B(point) }
    #[func] fn BOTTOMRIGHT(point: Vector2i) -> Vector2i{ Self::BR(point) }

}

