using Godot;
using System;

public partial class TestSql : Node
{
	public override void _Ready()
	{
		
		var sql = SQLite.create("res://sample.db");

	}

}
