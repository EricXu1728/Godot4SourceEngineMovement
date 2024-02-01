using Godot;
using System;
[Tool]

public partial class interateNode : Node
{
	private Boolean _build = false;
	[Export] Boolean Build
	{
		get => false;
		set
		{
			// This is ran every time Build is updated.
			//Update when building
			if (Engine.IsEditorHint() && value != Build){
				GD.Print("Building?");
				//GD.Print(distance);
				//spawnNodes();
			}
		}
	}
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
