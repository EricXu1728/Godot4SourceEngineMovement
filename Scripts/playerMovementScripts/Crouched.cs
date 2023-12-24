
using System;
using Godot;

namespace StateMachine;
public partial class Crouched : playerState
{
	 
	public Boolean tryUncrouch = false;
	
	public override void Enter(String msg)
	{  
		GD.Print("crouched");
		stats.crouched = true;
		stats.speed = stats.ply_crouchspeed ;
		tryUncrouch = false;
		
		
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
		if(player.bonker.IsColliding())
		{
			GD.Print("bonking");
	
	
		}
	}
	
	
	
}
