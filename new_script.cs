using Godot;
using System;



public partial class new_script : Node
{

	[Export] public playerVariables.player_vars stats;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//GD.Print("wow");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		//GD.Print("wow2");
		//GD.Print(stats.ply_mousesensitivity);
		//GD.Print("wow3");
	}
}
