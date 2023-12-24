
using System;
using Godot;
using Dictionary = Godot.Collections.Dictionary;
using Array = Godot.Collections.Array;
// Air.gd
namespace StateMachine;
public partial class Air : playerState
{
	//I hate how inheritence works
	


	// If we get a message asking us to jump, we jump.
	public override void Enter(String msg)
	{  
		GD.Print("AIR");
		stats.on_floor = false;
		if(msg == "do_jump")
		{
			//player.ClearCoyote()
			CheckJumpButton();
	
		}
	}
	
	public override void PhysicsUpdate(double delta)
	{  
		AirMove(delta);
		

	
		if(stats.on_floor)// && Mathf.Abs(player.velocity[1])<15:
		{
			
			ownerStateMachine.TransitionTo("Run");
		}
		else
		{
			if(Input.IsActionPressed("jump"))
			{
				CheckJumpButton();
	
	
			}
		}
	}
	
	public void AirMove(double delta)
	{  
		Vector3 forward = Vector3.Forward;
		Vector3 side = Vector3.Left;

		forward = forward.Rotated(Vector3.Up, player.camera.Rotation[1]);
		side = side.Rotated(Vector3.Up, player.camera.Rotation[1]);
	
		forward = forward.Normalized();
		side = side.Normalized();
		
		Vector3 tempVel = stats.vel;
		tempVel[1] -= (float)(stats.ply_gravity * delta);
		stats.vel = tempVel;
		//print("huh ",stats.vel[1])
		
	
		float fmove = stats.forwardmove;
		float smove = stats.sidemove;
	
		stats.snap = Vector3.Zero;
	
		Vector3 wishvel = side * smove + forward * fmove;
	
		// Zero out y value
		wishvel[1] = 0;
	
		Vector3 wishdir = wishvel.Normalized();
		// VectorNormalize in the original source code doesn't actually return the length of the normalized vector
		// It returns the length of the vector before it was normalized
		float wishspeed = wishvel.Length();
		
	
		// clamp to game defined max speed
		if(wishspeed != 0.0 && wishspeed > stats.ply_maxspeed)
		{
			wishvel *= stats.ply_maxspeed / wishspeed;
			wishspeed = stats.ply_maxspeed;
		//print(stats.ply_airaccelerate, " ", stats.ply_airspeedcap)
		}
		AirAccelerate(wishdir, wishspeed, stats.ply_airaccelerate, delta);
		player.CheckVelocity();
	
	}
	
	public void AirAccelerate(Vector3 wishdir, float wishspeed, int accel, double delta)
	{  
		// cap speed
		wishspeed = Mathf.Min(wishspeed, stats.ply_airspeedcap);
		// See if we are changing direction a bit
		float currentspeed = stats.vel.Dot(wishdir);
		// Reduce wishspeed by the amount of veer.
		float addspeed = wishspeed - currentspeed;
	
		// If !going to add any speed, done.
		if(addspeed <= 0)
		{
			return;
	
		// Determine amount of accleration.
		}
		float accelspeed = (float)(accel * wishspeed * delta);
		// Cap at addspeed
		accelspeed = Mathf.Min(accelspeed, addspeed);
		
	
		foreach(int i in GD.Range(3))
		{
			// Adjust velocity.
			stats.vel += wishdir * accelspeed;

		}
	}
	
	public void CheckJumpButton()
	{  
		
		
		stats.snap = Vector3.Zero;
	
		if(!(stats.shouldJump))//||  player.velocity[1]>15:
		{
			return;
	
		}
		player.ClearCoyote();
		
		
		float flGroundFactor = 1.0f;
		
		
		float flMul;
		
		
		flMul = Mathf.Sqrt(2 * stats.ply_gravity * stats.ply_jumpheight);
		
		float jumpvel =  flGroundFactor * flMul  + Mathf.Max(0, stats.vel[1]);// 2 * gravity * height
		
		Vector3 tempVel = stats.vel;
		tempVel[1]= Mathf.Max(jumpvel, jumpvel + stats.vel[1]);
		stats.vel = tempVel;
		GD.Print("Coyote jump: ",stats.vel[1]);
	
	
	}
	
	
	
}
