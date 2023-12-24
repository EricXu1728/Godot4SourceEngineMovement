
using System;
using Godot;


namespace StateMachine;
public partial class Standing : playerState
{
	 
	// If we get a message asking us to jump, we jump.
	public override void Enter(String msg)
	{  
		GD.Print("standing");
		stats.crouching = false;
		stats.crouched = false;
		stats.speed = stats.ply_maxspeed;


		Vector3 newScale = player.mySkin.Scale;
		newScale[1] =1;

		player.mySkin.Scale = newScale;
		player.myShape.Scale = newScale;
		
		
	}
	
	public override void PhysicsUpdate(double delta)
	{  
		if(Input.IsActionJustPressed("crouch"))
		{
			ownerStateMachine.TransitionTo("Crouching");
			
	
	
		}
	}
	
	
	
}
