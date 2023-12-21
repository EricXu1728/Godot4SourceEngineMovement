using Godot;
using System;

public partial class coin_counter : Label
{
	int coins = 0;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	public void update_counter(int count){
		coins += count;
		Text = "COINS: "+coins;
	}
}
