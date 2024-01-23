using Godot;
using System;

public partial class breakable : StaticBody3D
{
	private PackedScene explosion =  ResourceLoader.Load<PackedScene>("res://components/particle/breakableExplosion.tscn");
	private CollisionShape3D collision ;
	private AudioStreamPlayer3D streamer;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		streamer = GetNode<AudioStreamPlayer3D>("AudioStreamPlayer3D");
		collision = GetNode<CollisionShape3D>("CollisionShape3D");
		
		
	}

	
	public void DestroyBlock(){
		collision.QueueFree();
		explosiveSpark newSpark =  explosion.Instantiate<explosiveSpark>();
		
		newSpark.Position = this.Position ;
		
		streamer.Play();
		GetParent().AddChild(newSpark);
		
		GD.Print("exlodded");
		GD.Print(newSpark.Position);
		//QueueFree();
		
		Visible = false;
		
	}
	
	private void _on_audio_stream_player_3d_finished()
	{
		//QueueFree();
	}
	
}





