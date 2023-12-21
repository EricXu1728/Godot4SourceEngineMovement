using Godot;
using System;

public partial class coin_controller : Node3D
{
	
	[Export] public NodePath coin_label_path {get; set;}
	private coin_counter coin_label;

	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		coin_label = GetNode<coin_counter>(coin_label_path);
		
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
	}
	
	private void _on_coin_coin_collected(coin collected_coin)
	{
		GD.Print(collected_coin);
		
		coin_label.update_counter(1);
	}
	

}


