using Godot;
using System;

public partial class coin : Area3D
{
	// [Export] public NodePath signal_receiver = new NodePath("..");
	
	[Signal] public delegate void CoinCollectedEventHandler(coin collected_coin);

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
		// Node receiver = GetNode(signal_receiver);
		// GD.Print(receiver);
		// this.CoinCollected += receiver._on_coin_coin_collected;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	private void _on_body_entered(Node3D body)
	{
		EmitSignal(SignalName.CoinCollected, this);
		QueueFree();
	}

}


