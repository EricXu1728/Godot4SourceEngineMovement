using Godot;
using System;

public partial class HitBox : Area3D
{
	public Node owner;
	public Timer timer;
	private float time = -1;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		ReadyUp();
		if(time != -1){
			timer.WaitTime = time;
			timer.Start();
		
		}
		
	}

	public void ReadyUp(){

		timer = GetNode<Timer>("Timer");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		
		
	}
	
	public void SetParams(float time = -1){

		this.time = time;
		

	}
	private void _on_timer_timeout()
	{
		GD.Print("uua");
		QueueFree();
	}

}


