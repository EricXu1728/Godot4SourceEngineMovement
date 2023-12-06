
using System;
using Godot;
using Dictionary = Godot.Collections.Dictionary;
using Array = Godot.Collections.Array;


public class State : Node
{
	// Virtual base class for all states.
	 
	// Reference to the state machine, to call its `transition_to()` method directly.
	// That's one unorthodox detail of our state implementation, as it adds a dependency between the
	// state && the state machine objects, but we found it to be most efficient for our needs.
	// The state machine node will set it.
	public StateMachine stateMachine;
	
	
	// Virtual function. Receives events from the `_unhandled_input()` callback.
	public void HandleInput(InputEvent _event)
	{  
	
	
	// Virtual function. Corresponds to the `_process()` callback.
	}
	
	public void Update(float _delta)
	{  
	
	
	// Virtual function. Corresponds to the `_physics_process()` callback.
	}
	
	public void PhysicsUpdate(float _delta)
	{  
	
	
	// Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
	// is a dictionary with arbitrary data the state can use to initialize itself.
	}
	
	public void Enter(_msg := new Dictionary(){})
	{  
		// Virtual function. Called by the state machine before changing the active state. Use this function
		// to clean up the state.
	}
	
	public void Exit()
	{  
	
	
	}
	
	
	
}
