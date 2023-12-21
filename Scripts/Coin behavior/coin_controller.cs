using Godot;
using System;
using System.Collections.Generic;

public partial class coin_controller : Node3D
{	
	[Export] public NodePath coin_label_path {get; set;}
	[Export] public NodePath collector_path {get; set;}

	private coin_counter coin_label;
	private Node3D collector;

	private HashSet<coin> CollectedCoins = new HashSet<coin>();

	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		coin_label = GetNode<coin_counter>(coin_label_path);
		collector =  GetNode<Node3D>(collector_path);
		
		foreach(Node n in GetChildren()){
			switch(n.GetType().FullName){
				case "coin":
				//GD.Print("foundCoin");
				((coin)n).CoinCollected += _on_coin_coin_collected;
				break;

				case "coin_path":
				foreach(Node k in n.GetChildren()){
					if(k is coin){
						((coin)k).CoinCollected += _on_coin_coin_collected;
					}
				}
				break;
	
			}		
		}
		
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		List<coin> toRemove = new List<coin>();

		Vector3 collectorPos = collector.GlobalPosition + new Vector3(0,1,0);
		Vector3 target = collectorPos;

		foreach (coin c in CollectedCoins){
			//Vector3 dir = c.GlobalPosition.DirectionTo(collector.GlobalPosition);
			Vector3 direction_ = c.GlobalPosition.DirectionTo(target);
			float distance_ = c.GlobalPosition.DistanceTo(target);
			float speed_ = Math.Clamp(distance_ /2, 1, 10);

			c.GlobalPosition += direction_ * speed_;//c.GlobalPosition.Lerp(target, (float)(delta*50));
			
			target = c.GlobalPosition;

			if(c.GlobalPosition.DistanceTo(collectorPos) < 0.4){
				//toRemove.Add(c);
				toRemove.Add(c);

			}
		
		}

		//Remove 
		foreach (coin n in toRemove){
			coin_label.update_counter(1);
			
			CollectedCoins.Remove(n);
			//n.QueueFree();
			n.play_collection_animation();
		}


	}
	
	private void _on_coin_coin_collected(coin collected_coin)
	{
		
		CollectedCoins.Add(collected_coin);
		
		collected_coin.remove_shadow();
	}

}

