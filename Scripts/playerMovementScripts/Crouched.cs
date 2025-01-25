using System;
using Godot;

namespace StateMachine
{
	public partial class Crouched : playerState
	{
		public bool tryUncrouch = false;

		public override void Enter(string msg)
		{
			GD.Print("crouched");
			stats.crouched = true;
			stats.speed = stats.ply_crouchspeed;

			// Check for "try_uncrouch" in the message and update tryUncrouch
			if (msg.Contains("try_uncrouch"))
			{
				tryUncrouch = true;
			}
			else
			{
				tryUncrouch = false;
			}
		}

		public override void PhysicsUpdate(double delta)
		{
			if (Input.IsActionJustReleased("crouch"))
			{
				tryUncrouch = true;
			}

			if (tryUncrouch && !player.bonker.IsColliding())
			{
				ownerStateMachine.TransitionTo("Standing");
			}

			if (player.bonker.IsColliding())
			{
				GD.Print("bonking");
			}
		}
	}
}
