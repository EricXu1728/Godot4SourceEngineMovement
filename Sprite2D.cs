using Godot;
using System;



public partial class Sprite2D : Godot.Sprite2D
{
	float AMOUNT = 5;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		
		if (Input.IsActionPressed("ui_up"))
		{
			this.Position += new Vector2(0, -AMOUNT);
		}
		if (Input.IsActionPressed("ui_down"))
		{
			this.Position += new Vector2(0, AMOUNT);
		}
		if (Input.IsActionPressed("ui_left"))
		{
			this.Position += new Vector2(-AMOUNT,0);
		}
		if (Input.IsActionPressed("ui_right"))
		{
			this.Position += new Vector2(AMOUNT,0);
		}
	}
}

