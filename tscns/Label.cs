using Godot;
using System;

public partial class Label : Godot.Label
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("Woa");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}

using static Godot.GD;

public class Test
{
	static Test()
	{
		Print("Hello"); // Instead of GD.Print("Hello");
	}
}
