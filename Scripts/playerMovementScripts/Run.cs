
using System;
using Godot;
using Dictionary = Godot.Collections.Dictionary;

namespace StateMachine;
public partial class Run : playerState
{
	// Run.gd

	public override void Enter(String msg)
	{
		GD.Print("RUN");
	}

	public override void PhysicsUpdate(double delta)
	{
		if (player.canClimb && stats.on_floor == false && Input.IsActionPressed("move_forward") && stats.vel[1] > 10)
		{
			ownerStateMachine.TransitionTo("Climbing");
			GD.Print("TRy climb");
		}

		Move(delta);
	}

	public void Move(double delta)
	{
		//you would normaly have a check to see if velocity is too high && set to "air" to mimic source, but this feels better
		if (stats.on_floor)
		{
			WalkMove(delta);
		}
		else
		{

			ownerStateMachine.TransitionTo("Air");

		}
		if(Input.IsActionPressed("jump") && (stats.canJumpWhileCrouched||  !stats.crouched))
		{
			
			PerformJump();

			stats.on_floor = false;
			ownerStateMachine.TransitionTo("Air");

		}
		player.CheckVelocity();


	}

	public void WalkMove(double delta)
	{
		Vector3 forward = Vector3.Forward;
		Vector3 side = Vector3.Left;

		forward = forward.Rotated(Vector3.Up, player.camera.Rotation[1]);
		side = side.Rotated(Vector3.Up, player.camera.Rotation[1]);

		forward = forward.Normalized();
		side = side.Normalized();

		//stats.vel.y -= stats.ply_gravity * delta;


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
		if (wishspeed != 0.0 && wishspeed > stats.ply_maxspeed)
		{
			wishvel *= stats.ply_maxspeed / wishspeed;
			wishspeed = stats.ply_maxspeed;
			//print(stats.ply_airaccelerate, " ", stats.ply_airspeedcap)
		}

		Friction(delta);
		Accelerate(wishdir, wishspeed, stats.ply_accelerate, delta);


	}

	public void Accelerate(Vector3 wishdir, float wishspeed, int accel, double delta)
	{
		float currentspeed = stats.vel.Dot(wishdir);
		// Reduce wishspeed by the amount of veer.
		float addspeed = wishspeed - currentspeed;

		// If !going to add any speed, done.
		if (addspeed <= 0)
		{
			return;

			// Determine amount of accleration.
		}
		float accelspeed = (float)(accel * wishspeed * delta);

		// Cap at addspeed

		foreach (int i in GD.Range(3))
		{
			// Adjust velocity.
			stats.vel += accelspeed * wishdir;

			//reduce straifing on ground


		}

	}

	public void Friction(double delta)
	{
		// If we are in water jump cycle, don't apply friction
		//if (player->m_flWaterJumpTime)
		//	return

		// Calculate speed
		float speed = stats.vel.Length();

		// If too slow, return
		//
		if (speed < 0)
		{
			return;


		}
		float drop = 0;

		// apply ground friction
		float friction = stats.ply_friction;

		// Bleed off some speed, but if we have less than the bleed
		//  threshold, bleed the threshold amount.
		float control = speed < stats.ply_stopspeed ? stats.ply_stopspeed : speed;
		// Add the amount to the drop amount.
		drop += (float)(control * friction * delta);

		// scale the velocity
		float newspeed = speed - drop;
		if (newspeed < 0)
		{
			newspeed = 0;

		}
		if (newspeed != speed)
		{
			// Determine proportion of old speed we are using.
			newspeed /= speed;
			// Adjust velocity according to proportion.
			stats.vel *= newspeed;

		}
	}

	public void PerformJump()
	{
		stats.snap = Vector3.Zero;

		if (!stats.shouldJump)// || player.velocity.Y > 15)
		{
			return;
		}

		player.ClearCoyote();

		float flGroundFactor = 1.0f;
		float flMul;

		if (stats.crouching)
		{
			flMul = (float)Math.Sqrt(2 * stats.ply_gravity * stats.ply_jumpheight) + (1.0f / 60.0f) * stats.ply_gravity;

			if (!stats.crouched)
			{
				player.MoveAndCollide(new Vector3(0, 2 - player.myShape.Scale.Y, 0));
			}
		}
		else
		{
			flMul = (float)Math.Sqrt(2 * stats.ply_gravity * stats.ply_jumpheight);
		}

		float jumpvel = flGroundFactor * flMul;// + Math.Max(0, stats.vel.Y);
		stats.vel = new Vector3(stats.vel.X, Math.Max(jumpvel, jumpvel + stats.vel.Y), stats.vel.Z);
		//stats.vel.y = max(jumpvel, jumpvel + stats.vel.y)
		GD.Print("Normal jump: ", stats.vel.Y);
	}



}
