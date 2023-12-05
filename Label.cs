
using System;
using Godot;
using Dictionary = Godot.Collections.Dictionary;
using Array = Godot.Collections.Array;


public class Label : Godot.Label
{
	 
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{  
		GD.Print("Woa")
		pass ;// Replace with function body.
	
	
	
	}
	
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		GD.Print("Woa")
		this.SetText( GD.Str(Engine.GetFramesPerSecond() ));
	}
	
	
}
