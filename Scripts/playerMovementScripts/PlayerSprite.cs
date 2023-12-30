using Godot;
using System;

public partial class PlayerSprite : Node3D
{
	private Sprite3D outline;
	private Sprite3D color;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		outline = GetNode<Sprite3D>("Outline");
		color = GetNode<Sprite3D>("Outline/color");
		outline.SortingOffset = 1;
	}

	public int getFrame(){
		return outline.Frame;
	}

	public void setFrame(int frame){
		outline.Frame = frame;
		color.Frame = frame;
	}

}
