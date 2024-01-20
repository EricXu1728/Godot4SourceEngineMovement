using Godot;
using System;
using System.ComponentModel.DataAnnotations;
using System.Xml.Schema;

namespace StateMachine;
public partial class Climbing : playerState
{
	private Vector3 enterVector = Vector3.Zero;
	private float enterSpeed = 0;
	private Vector3 newVel = Vector3.Zero;
	private double climbTime = 0;
	
	public override void Enter(String msg)
	{  
		//enterVector = stats.vel;


		//enterSpeed = new Vector2(enterVector[0], enterVector[2]).Length();
		
		//Vector3 newVel = stats.vel;
		//newVel[1] = enterSpeed + (newVel[1]/2);
		//stats.vel = newVel;
			
		//GD.Print(enterVector);
		//GD.Print(enterSpeed);
		//GD.Print("Climbing");
		
		
		//GD.Print("Lost");
		//GD.Print(stats.lostSpeed);
		Vector2 sideVelocity = new Vector2(stats.vel[0],stats.vel[2]);
		Vector2 sideNormal = sideVelocity.Normalized();


		//stats.vel *= player.climbAngle;
		//GD.Print("Climb");
		//GD.Print(player.climbAngle);
		//GD.Print("side");
		//GD.Print(sideNormal);
		////Vector3 climbVector = new Vector3(0, 1,0);//player.climbAngle + stats.vel.Normalized();
		//climbVector[1] = player.climbAngle[1] + 1;
		//climbVector[1] +=1;
		Vector3 wantedDirection = Vector3.Zero;
		wantedDirection[0] = sideNormal[0] + (player.climbAngle[0]*0.0f);
		wantedDirection[1] =  + player.climbAngle[1]+1;
		wantedDirection[2] = sideNormal[1] + (player.climbAngle[2]*0.0f);

		//GD.Print(wantedDirection);

		wantedDirection = wantedDirection.Normalized();

		Vector3 speed =stats.vel;
		speed[1] = MathF.Max(0, speed[1]);
	
		stats.vel = wantedDirection * speed.Length();
	}
	
	public override void PhysicsUpdate(double delta)
	{ 
		stats.ply_climbspeedcap = stats.vel.Length();
		stats.ply_climbaccelerate = stats.ply_climbspeedcap/ 5f;
		climbTime += delta;

		ClimbMove(delta);
		if(!Input.IsActionPressed("move_forward")){
			ownerStateMachine.TransitionTo("Air");
			GD.Print("Self exit");
		
		}
		if(player.canClimb==false || stats.on_floor==true){ //player.canClimb
			ownerStateMachine.TransitionTo("Air");
			
			float removeRatio = 0.3f;
			
			float removed_speed = stats.vel[1]*(removeRatio);
			
			Vector3 newVel = stats.vel;
			newVel[1] *= (1-removeRatio);
			
			Vector2 addSpeed = new Vector2(1f, 0f).Rotated(Mathf.DegToRad(-stats.ylook-90)) * removed_speed ;
			GD.Print(stats.ylook);
			
			newVel[0] += addSpeed[0];
			newVel[2] += addSpeed[1];
			
			stats.vel = newVel;
			
			
			
			
			GD.Print("fell off");
		}
		
	}
	public void ClimbMove(double delta)
	{  
		Vector3 forward = Vector3.Forward;
		Vector3 side = Vector3.Left;

		forward = forward.Rotated(Vector3.Up, player.camera.Rotation[1]);
		side = side.Rotated(Vector3.Up, player.camera.Rotation[1]);
	
		forward = forward.Normalized();
		side = side.Normalized();
		
		Vector3 tempVel = stats.vel;
		tempVel[1] -= (float)(stats.ply_gravity * delta)*0.05f;
		stats.vel = tempVel;
		
	
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
		//print(stats.ply_climbaccelerate, " ", stats.ply_climbspeedcap)
		}
		ClimbAccelerate(wishdir, wishspeed, stats.ply_climbaccelerate, delta);
		player.CheckVelocity();
	
	}
	
	public void ClimbAccelerate(Vector3 wishdir, float wishspeed, float accel, double delta)
	{  
		// cap speed
		wishspeed = Mathf.Min(wishspeed, stats.ply_climbspeedcap);
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
}
