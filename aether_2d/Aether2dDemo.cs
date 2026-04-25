using Godot;
using nkast.Aether.Physics2D.Dynamics;


public partial class Aether2dDemo : CanvasLayer
{

	private struct Ball
	{
		public Body body;
		public Fixture shape;

		public Ball(Body _body)
		{
			body = _body;
			shape = _body.CreateCircle(10.0f, 1f);
		}
	}

	// CanvasItem
	private Rid _cid;

	// Aether2D World
	private World _world;


	private Body box;
	private Vector2 box_size;
	private Fixture[] body_edges = new Fixture[4];
	

	private int amount = 100;
	private float radius = 10.0f;
	private Ball[] balls;


	public static nkast.Aether.Physics2D.Common.Vector2 to_aether_vec2(in Vector2 value)
	{
		return new nkast.Aether.Physics2D.Common.Vector2(
			value.X, value.Y
		);
	}


	public static nkast.Aether.Physics2D.Common.Vector2 ZERO => new nkast.Aether.Physics2D.Common.Vector2(.0f, .0f);


    public override void _EnterTree()
    {
        base._EnterTree();

		

    }

	public void Create()
	{
		_cid = RenderingServer.CanvasItemCreate();

		_world = new World();


		// Create Box
		box = _world.CreateBody(ZERO, .0f, BodyType.Static);

		Rect2 box_rect = new Rect2(- box_size / 2.0f, box_size);
		Vector2[] rect_polygon = [
			box_rect.Position,
			new Vector2(box_rect.Position.X, box_rect.Position.Y + box_rect.Size.Y),
			box_rect.Position + box_rect.Size,
			new Vector2(box_rect.Position.X + box_rect.Size.X, box_rect.Position.Y),
			box_rect.Position,
		];

		for (int i = 0; i < 4; i += 1)
		{
			var from = to_aether_vec2(rect_polygon[i]);
			var to = to_aether_vec2(rect_polygon[i + 1]);

			body_edges[i] = box.CreateEdge(from, to);
		}


		// Let's create balls
		balls = new Ball[amount];
		for (int j = 0; j < amount; j += 1)
		{
			var rand = new RandomNumberGenerator();
			var randx = rand.RandfRange(box_rect.Position.X, box_rect.Position.X + box_rect.Size.X);
			var randy = rand.RandfRange(box_rect.Position.Y, box_rect.Position.Y + box_rect.Size.Y);
			Vector2 spawn_position = new Vector2(randx, randy);

			var ball = new Ball(_world.CreateBody());

		}

	}


	public override void _PhysicsProcess(double delta)
	{
		if (_world != null)
		{
			_world.Step((float)delta);
		}
	}
}
