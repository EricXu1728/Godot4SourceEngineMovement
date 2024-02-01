using Godot;
using System;
using System.ComponentModel;

public partial class coin : Area3D
{
	private PackedScene explosion =  ResourceLoader.Load<PackedScene>("res://components/particle/explosiveSpark.tscn");
	
	[Signal] public delegate void CoinCollectedEventHandler(coin collected_coin);
	[Signal] public delegate void CoinDestroyedEventHandler();

	public Boolean interacted = false;

	private AnimationPlayer coinAnimePlayer;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{

		coinAnimePlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		coinAnimePlayer.SpeedScale = 1.5F;
		//GD.Print(coinAnimePlayer);
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
		//QueueFree();
	}
	public void play_collection_animation(){

		coinAnimePlayer.Play("coin_collect");

	}
	
	public void remove_shadow(){
		Node n = GetNode<Node>("shadow");
		n.QueueFree();
	}
	
	private void _on_animation_player_animation_finished(StringName anim_name)
	{
		explosiveSpark newSpark =  explosion.Instantiate<explosiveSpark>();
		
		newSpark.Position = this.Position + new Vector3(0,2,0);
		
		GetParent().AddChild(newSpark);

		EmitSignal(SignalName.CoinDestroyed);

		QueueFree();
	}

}




