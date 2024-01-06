using Godot;
using System;
using playerVariables;

public partial class test_script : Label
{
	[Export] public player_vars stats {get; set;}
	[Export] public Player player {get; set;}

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{

		Text = player.canClimb+"\n"+stats.on_floor+"\n"+stats.vel;
	}
}
