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

	Vector2 prevVel = Vector2.Zero;
	Vector2 lost_speed = Vector2.Zero;
	float max = 0;
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Vector2 horizVel = new Vector2( stats.vel[0],  stats.vel[2]);
		lost_speed = horizVel - prevVel;
		Text = GD.VarToStr(lost_speed);//player.canClimb+"\n"+stats.on_floor+"\n"+stats.vel;
		prevVel =  horizVel;
		max = Math.Max(max, lost_speed.Length());
		//GD.Print(max);
	}


	public override void _Draw()
	{
		Color col = new Color(1,0,0);
		Rect2 square = new Rect2(new Vector2(20, lost_speed.Length()*10),new Vector2(50, 50));
		DrawRect(square, col);
	}
}

