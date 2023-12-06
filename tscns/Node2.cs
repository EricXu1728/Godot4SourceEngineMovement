using Godot;
using System;

public partial class Node2 : Node
{
	[Export] public playerVariables.player_vars stats;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		//stats.ply_mousesensitivity += 1;
		//GD.Print(stats.ply_mousesensitivity);
	}
}
