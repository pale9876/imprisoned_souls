using Godot;
using System;

public partial class test_cs : Node2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("hello");
		var cid = RenderingServer.CanvasItemCreate();
		RenderingServer.CanvasItemSetParent(GetCanvasItem(), cid);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
