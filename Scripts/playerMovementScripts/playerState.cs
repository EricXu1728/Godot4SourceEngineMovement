// Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
// Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
using Godot;
using System;
using StateMachine;
using System.Diagnostics;
using playerVariables;

namespace StateMachine;
public partial class playerState : State
{
	protected Player player;
	protected player_vars stats;


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		// The states are children of the `Player` node so their `_ready()` callback will execute first.
		// That's why we wait for the `owner` to be ready first.
		var _owner = GetParent().GetParent<Player>();
		player = _owner;
		//await _owner.ready;
		// The `as` keyword casts the `owner` variable to the `Player` type.
		// If the `owner` is not a `Player`, we'll get `null`.

		stats = player.stats;

		// This check will tell us if we inadvertently assign a derived state script
		// in a scene other than `Player.tscn`, which would be unintended. This can
		// help prevent some bugs that are difficult to understand.

		Debug.Assert(player != null);
	}


	public Player GetPlayer(){
		return player;
	}

	public player_vars GetStats(){
		return stats;
	}

}
