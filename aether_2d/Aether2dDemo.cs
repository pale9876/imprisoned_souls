using System;
using Godot;
using nkast.Aether.Physics2D.Collision;
using nkast.Aether.Physics2D.Dynamics;

using NkastVec2 = nkast.Aether.Physics2D.Common.Vector2;

[Tool]
public partial class Aether2dDemo : CanvasLayer
{
	private struct Ball
	{
		public Rid cid;
		public Body body;
		public Fixture shape;
		public Vector2 position = Vector2.Zero;
		public Vector2 motion;

		public Ball(Body _body, Vector2 init_pos, Vector2 init_motion)
		{
			cid = RenderingServer.CanvasItemCreate();
			position = init_pos;
			body = _body;
			shape = _body.CreateCircle(10.0f, 1f);
			motion = init_motion;
			
			RenderingServer.CanvasItemAddCircle(cid, new Vector2(), 10.0f, Colors.White);
			RenderingServer.CanvasItemSetTransform(cid, get_transform());

		}

		public Transform2D get_transform()
		{
			return new Transform2D(0.0f, position);
		}
	}


	private struct Box
	{
		public Rid cid;
		public Body body;
		public Fixture[] edges;

		public Box(Body _body, Rect2 rect)
		{
			cid = RenderingServer.CanvasItemCreate();

			body = _body;
			
			edges = new Fixture[4];
			Vector2[] rect_polygon = [
				rect.Position,
				new Vector2(rect.Position.X, rect.Position.Y + rect.Size.Y),
				rect.Position + rect.Size,
				new Vector2(rect.Position.X + rect.Size.X, rect.Position.Y),
				rect.Position,
			];

			for (int i = 0; i < 4; i += 1)
			{
				var from = to_aether_vec2(rect_polygon[i]);
				var to = to_aether_vec2(rect_polygon[i + 1]);

				edges[i] = body.CreateEdge(from, to);
			}

			RenderingServer.CanvasItemAddRect(cid, rect, Colors.Aqua);
		}
	}


	// CanvasItem
	private Rid _cid;
	private Rid debug_canvas;

	// Aether2D World
	private World _world;


	private Fixture[] body_edges = new Fixture[4];
	private Vector2 box_size = new Vector2(100.0f, 100.0f);
	private Box box;
	

	private int amount = 100;
	private float radius = 10.0f;
	private Ball[] balls;


	private bool init = false;

	[ExportToolButton("Create", Icon = "2D")]
	private Callable _create => Callable.From(create);


	public static NkastVec2 to_aether_vec2(in Vector2 value)
	{
		return new NkastVec2(
			value.X, value.Y
		);
	}


	public static NkastVec2 ZERO => new NkastVec2(.0f, .0f);


    public override void _EnterTree()
    {
        base._EnterTree();

		if (!Engine.IsEditorHint())
		{
			create();
		}

    }

	public void create()
	{
		if (init)
		{
			kill();
		}

		_cid = RenderingServer.CanvasItemCreate();
		RenderingServer.CanvasItemSetParent(GetCanvas(), _cid);

		if (Engine.IsEditorHint())
		{
			debug_canvas = RenderingServer.CanvasItemCreate();
			
		}
		else if (!Engine.IsEditorHint())
		{
			// Create World
			_world = new World();

			// Create Box
			Rect2 box_rect = new Rect2(- box_size / 2.0f, box_size);

			box = new Box (
				_world.CreateBody(ZERO, .0f, BodyType.Static),
				box_rect
			);
			RenderingServer.CanvasItemSetParent(box.cid, _cid);


			// Create Balls
			balls = new Ball[amount];
			for (int j = 0; j < amount; j += 1)
			{
				var rand = new RandomNumberGenerator();
				var randx = rand.RandfRange(box_rect.Position.X, box_rect.Position.X + box_rect.Size.X);
				var randy = rand.RandfRange(box_rect.Position.Y, box_rect.Position.Y + box_rect.Size.Y);
				Vector2 spawn_position = new Vector2(randx, randy);
				Vector2 rand_dir = Vector2.FromAngle(rand.RandfRange(.0f, float.Tau));
				float init_force = 300.0f;

				Vector2 motion = init_force * rand_dir;

				var ball = new Ball(
					_world.CreateBody(to_aether_vec2(spawn_position), .0f, BodyType.Kinematic),
					spawn_position, motion
				);

				RenderingServer.CanvasItemSetParent(ball.cid, _cid);
				balls[j] = ball;
			}
		}

		init = true;
	}


	public void kill()
	{

		if (!Engine.IsEditorHint())
		{
			_world.Remove(box.body);
			RenderingServer.FreeRid(box.cid);

			foreach (var ball in balls)
			{
				_world.Remove(ball.body);
				RenderingServer.FreeRid(ball.cid);
			}
		}
	}

	private float test_move(Fixture fixture, NkastVec2 point, NkastVec2 normal, float fraction)
	{
		return -1.0f;
	}

	public override void _PhysicsProcess(double delta)
	{
		if (!Engine.IsEditorHint())
		{
			foreach (var ball in balls)
			{
				ball.body.LinearVelocity = to_aether_vec2(ball.motion);
			}
			_world.Step((float)delta);
		}		
	}

}
