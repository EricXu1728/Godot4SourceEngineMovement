using Godot;
using System;

public partial class explosiveSpark : GpuParticles3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Emitting = true;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	private void _on_finished()
	{
		Callable callable = new Callable(this, MethodName.QueueFree);
		callable.CallDeferred();
		GetParent().RemoveChild(this);
		QueueFree();
	}

	
}


