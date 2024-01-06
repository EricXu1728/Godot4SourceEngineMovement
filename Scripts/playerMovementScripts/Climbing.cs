using Godot;
using System;

namespace StateMachine;
public partial class Climbing : playerState
{
	private Vector3 enterVector = Vector3.Zero;
	private float enterSpeed = 0;
	private Vector3 newVel = Vector3.Zero;
	
	public override void Enter(String msg)
	{  
		enterVector = stats.vel;


		enterSpeed = new Vector2(enterVector[0], enterVector[2]).Length();
		
		Vector3 newVel = stats.vel;
		newVel[1] = enterSpeed + (newVel[1]/2);
		stats.vel = newVel;
			
		GD.Print(enterVector);
		GD.Print(enterSpeed);
		GD.Print("Climbing");
	}
	
	public override void PhysicsUpdate(double delta)
	{ 
		if(player.canClimb==false || stats.on_floor==true || Input.IsActionJustReleased("move_forward")){ //player.canClimb
			ownerStateMachine.TransitionTo("Air");
		}else{
			
			
		}
		
	}
}
