using Godot;
using System;
using StateMachine;

public partial class stateMachine : Node
{
	[Signal] public delegate void transitionedEventHandler(string state_name);
	
	[Export] public State initial_state {get; set;}

	public State state;

	public override void _Ready(){
		state = initial_state;	
	
		
		foreach(State child in GetChildren()){
			GD.Print(child);
			child.ownerStateMachine = this;
		}
	}

	public override void _UnhandledInput(InputEvent _event)
	{
   		state.HandleInput(_event);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{  
		state.Update(delta);
	}

	public override void _PhysicsProcess(double delta)
	{  
		state.PhysicsUpdate(delta);
	
	}

	public void TransitionTo(String targetStateName, string msg)
	{  
		// Safety check, you could use an System.Diagnostics.Debug.Assert() here to report an error if the state name is incorrect.
		// We don't use an assert here to help with code reuse. If you reuse a state in different state machines
		// but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
		if(!HasNode(targetStateName))
		{
			return;
	
		}
		state.Exit();
		state = GetNode<State>(targetStateName);
		state.Enter(msg);
		EmitSignal("transitioned", state.Name);
	
	
	}
}

