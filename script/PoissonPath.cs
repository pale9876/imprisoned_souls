using Godot;
using System;



[GlobalClass]
public partial class PoissonPath : Path2D
{
	
	[Export] private PackedScene scene;
	[Export] public int amount = 10;
	[Export(PropertyHint.Range, "0., 1., .001")] public float density = .1f;

	// OVERRIDE
	public virtual void throw_dart()
	{
		var total_length = Curve.GetBakedLength();
		
		// pick random point

	}


}
