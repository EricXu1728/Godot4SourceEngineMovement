
using Godot;
using System;
using System.Collections.Generic;

[Tool]
public partial class coin_path : Path3D
{
	private static PackedScene COIN = (PackedScene)ResourceLoader.Load("res://level components/coin.tscn");
	
	private float _distance = 20;
	
	private List<Area3D> coins = new List<Area3D>(); 
	
	private PathFollow3D followPath;
	
	[Export]
	public float distance
	{
		get => _distance;
		set
		{
			// Update distance and reset the rotation.
			
			if(value<=0){
				_distance = 0.1f;
			}else{
				_distance = value;
			}
			spawn_coins();
		}
	}
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		followPath = GetNode<PathFollow3D>("PathFollow3D");
		spawn_coins();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	

	public void spawn_coins(){
		followPath = GetNode<PathFollow3D>("PathFollow3D");
		foreach(Node3D n in coins){
			n.QueueFree();
		}
		coins.Clear();
		
		
		
		float length = this.Curve.GetBakedLength();
		//GD.Print(length);

		float progress = 0;

		while(progress <length){
			progress +=distance;
			//GD.Print(progress);
			followPath.Progress = progress;
			
			Vector3 position_to_spawn = followPath.Position;
			add_coin(position_to_spawn);

			//GD.Print("coinsspawned");
		//	GD.Print(position_to_spawn);
		}

		
	}
	
	public Area3D add_coin(Vector3 position){
		Area3D newCoin = (Area3D)COIN.Instantiate();
		AddChild(newCoin);
		newCoin.Position = position;
		coins.Add(newCoin);
		return newCoin;
	}
	
	
	private void _on_curve_changed()
	{
		spawn_coins();
		// Replace with function body.
	}
	

}


