use godot::prelude::*;
use godot::classes::{CanvasLayer, Curve2D, Engine, ICanvasLayer, PhysicsServer2D, RenderingServer, physics_server_2d};


pub struct BouncingBall
{
    cid: Rid,
    body: Rid,
    shape: Rid,
    radius: f32,
    speed: f32,
}


impl Default for BouncingBall
{
    fn default() -> Self {
        Self::create(10.)
    }
}


impl BouncingBall
{
    fn create(_radius: f32) -> Self
    {
        type BodyMode = physics_server_2d::BodyMode;
        type BodyState = physics_server_2d::BodyState;

        let mut ps = PhysicsServer2D::singleton();
        let mut rs = RenderingServer::singleton();
        
        let _body: Rid = ps.body_create();
        ps.body_set_mode(_body, BodyMode::KINEMATIC);

        let _shape: Rid = ps.circle_shape_create();
        ps.shape_set_data(_shape, &_radius.to_variant());
        ps.body_add_shape_ex(_body, _shape)
            .transform(Transform2D::IDENTITY)
            .disabled(false)
            .done();
        ps.body_set_state(_body, BodyState::TRANSFORM, &Transform2D::from_angle_origin(0., Vector2::ZERO).to_variant());

        let _canvas_item = rs.canvas_item_create();
        rs.canvas_item_add_circle(_canvas_item, Vector2::ZERO, _radius, Color::WHITE);

        Self {
            cid : _canvas_item,
            body: _body,
            shape: _shape,
            radius: _radius,
            speed: 300.
        }
    }

    fn kill(&mut self)
    {
        let mut ps = PhysicsServer2D::singleton();
        let mut rs = RenderingServer::singleton();

        ps.free_rid(self.body);
        ps.free_rid(self.shape);
        rs.free_rid(self.cid);
        
    }


    fn moved(&mut self)
    {
        let ps = PhysicsServer2D::singleton();
        
    }

}


#[derive(GodotClass)]
#[class(tool, base=CanvasLayer, init)]
pub struct TestBox
{
    #[init(val = 100)]
    amount: u16,
    #[init(val = Rid::Invalid)]
    cid: Rid,
    #[init(val = Rid::Invalid)]
    body: Rid,
    #[init(val = Rid::Invalid)]
    shape: Rid,
    #[init(val = Vector2{x:100., y: 100.})]
    size: Vector2,
    balls: Vec<BouncingBall>,
    segments: Vec<Rid>,
    init: bool,

    #[export_tool_button(fn = Self::create, icon = "2D", name = "Create")]
    _create: PhantomVar<Callable>,

    base: Base<CanvasLayer>,
}


#[godot_api]
impl ICanvasLayer for TestBox
{
    fn physics_process(&mut self, delta: f32)
    {
        if !Engine::singleton().is_editor_hint()
        {
            
        }
    }
}

#[godot_api]
impl TestBox
{
    #[func]
    fn create(&mut self)
    {
        let mut rs = RenderingServer::singleton();
        let mut ps = PhysicsServer2D::singleton();
        let mut space: Rid = self.get_space();

        self.cid = rs.canvas_item_create();
        self.body = ps.body_create();

        
        // Let's make a Spawn Path
        let mut spawn_path: Gd<Curve2D> = Curve2D::new_gd();
        spawn_path.set_point_count(5);
        // spawn_path.set_point_position(0, Vector2{});
        
        // Then, We have to make a Box segments
        self.segments.resize(4, Rid::Invalid);
        for i in 0..4
        {
            let segment = ps.segment_shape_create();
            
            ps.shape_set_data(
                segment, &Rect2{position: Vector2::ZERO, size: Vector2::ZERO}.to_variant()
            );

            ps.body_add_shape_ex(self.body, segment)
                .transform(Transform2D::IDENTITY)
                .disabled(false)
                .done();
        }

        // 
        let amount_size = self.amount as usize;
        self.balls.resize_with(amount_size, BouncingBall::default);
        for i in 0..amount_size
        {
            let mut ball = BouncingBall::create(10.);
            ps.body_set_space(ball.body, space);
            rs.canvas_item_set_parent(ball.cid, self.to_gd().get_canvas());
            self.balls[i] = ball;
        }
    } 


    fn kill(&mut self)
    {
        self.balls.clear();
    }

    fn get_space(&mut self) -> Rid {self.to_gd().get_viewport().unwrap().get_world_2d().unwrap().get_space()}

}
