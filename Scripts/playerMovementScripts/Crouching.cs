
using System;
using Godot;

namespace StateMachine;

public partial class Crouching : playerState
{
	 
	public Boolean tryUncrouch = false;
	
	public override void Enter(String msg)
	{  
		GD.Print("crouching");
		stats.crouching = true;
		tryUncrouch = false;
		stats.speed = stats.ply_crouchspeed ;
		
	}
	
	public override void PhysicsUpdate(double delta)
	{  
		if(Input.IsActionJustReleased("crouch"))
		{
			tryUncrouch = true;
			
		}
		if(tryUncrouch == true && player.bonker.IsColliding() == false)
		{
	
			ownerStateMachine.TransitionTo("Standing");
			
			
		}

		Vector3 newScale = player.myShape.Scale;
		newScale[1] -=0.1f;
		newScale[1] = (float)Mathf.Clamp(newScale[1], 0.1, 1);

		player.myShape.Scale = newScale;
		player.mySkin.Scale = newScale;
		
		
		if(stats.on_floor)
		{
			player.MoveAndCollide(new Vector3(0,-0.1f, 0));
		}
		else
		{
			player.MoveAndCollide(new Vector3(0,0.1f, 0));
		
		}
		if(newScale[1] <=0.5){
			ownerStateMachine.TransitionTo("Crouched");
		}
	
	
	}
	
	
	
}