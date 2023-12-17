using Godot;
using System;

namespace StateMachine;

public partial class stateMachine : Node
{
	[Signal] public delegate void transitionedEventHandler(string state_name);
	
	[Export] public NodePath initial_state = new NodePath();
	Node state;
	
	public override void _Ready(){
		state = GetNode<Node>(initial_state);
		
		
	}
	
	
}

/*

using System;
using Godot;
using Dictionary = Godot.Collections.Dictionary;
using Array = Godot.Collections.Array;


public class stateMachine1 : Node
{
	// Generic state machine. Initializes states && delegates engine callbacks
	// (_physicsProcess, _unhandledInput) to the active state.
	 
	// Emitted when transitioning to a new state.
	[Signal] delegate void Transitioned(stateName);
	
	// Path to the initial active state. We export it to be able to pick the initial state in the inspector.
	@export NodePath initialState  = new NodePath();
	
	// The current active state. At the start of the game, we get the `initial_state`.
	@onready State state = GetNode(initialState);
	
	
	public async void _Ready()
	{  
		await owner.ready
		// The state machine assigns itself to the State objects' stateMachine property.
		
		foreach(var child in GetChildren())
		{
			//print(child.GetClass())
			child.state_machine = this;
		}
		state.Enter();
	
	
	// The state machine subscribes to node callbacks && delegates them to the state objects.
	}
	
	public void _UnhandledInput(InputEvent event)
	{  
		state.HandleInput(event);
	
	
	}
	
	public void _Process(float delta)
	{  
		state.Update(delta);
	
	
	}
	
	public void _PhysicsProcess(float delta)
	{  
		state.PhysicsUpdate(delta);
	
	
	// This function calls the current state's Exit() function, then changes the active state,
	// && calls its enter function.
	// It optionally takes a `msg` dictionary to pass to the next state's Enter() function.
	}
	
	public void TransitionTo(String targetStateName, Dictionary msg = new Dictionary(){})
	{  
		// Safety check, you could use an System.Diagnostics.Debug.Assert() here to report an error if the state name is incorrect.
		// We don't use an assert here to help with code reuse. If you reuse a state in different state machines
		// but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
		if(!has_node(targetStateName))
		{
			return;
	
		}
		state.Exit();
		state = GetNode(targetStateName);
		state.Enter(msg);
		EmitSignal("transitioned", state.name);
	
	
	}
	
	
	
}*/
