using Godot;
using System;


[Tool]
[GlobalClass]
public partial class PoissonPath : Path2D
{
	[Export] private PackedScene scene;
	[Export] public int amount = 10;
	[Export(PropertyHint.Range, "0., 1., .001")] public float density = .1f;


	[ExportToolButton("Test Draw Points")]
	private Callable _test => Callable.From(
		() => {
			throw_dart();
			QueueRedraw();
		}
	);

    public override void _Draw()
    {
        base._Draw();


    }


	// OVERRIDE
	public virtual void throw_dart()
	{

	}


}
