using Godot;
using System;
using playerVariables;
using System.ComponentModel;
using System.Runtime.CompilerServices;

//CODE THAT PARSES USER INPUT
//just organized like this for organization's sake

public partial class PlayerInputs : CharacterBody3D
{
	[Export] public player_vars stats;
	public Camera3D camera;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		throw new Exception("You should not be seeing this (player_inputs.gd is being initiated)");
	}

    public override void _Input(InputEvent @event)
    {
    	if ((@event is InputEventMouseMotion eventMouseMotion) && (Input.MouseMode == Input.MouseModeEnum.Captured)) {
			InputMouse(eventMouseMotion);
		}

		if(@event.IsActionPressed("ui_cancel")){
			Input.MouseMode = Input.MouseModeEnum.Visible;
		}

		if(@event.IsActionPressed("click")){
			if(Input.MouseMode == Input.MouseModeEnum.Visible){
				Input.MouseMode = Input.MouseModeEnum.Captured;
			}
		}

		if(@event.IsActionPressed("restart")){
			stats.vel = new Vector3(0,0,0);
			GetTree().ReloadCurrentScene();
		}

    }


	public void InputMouse(InputEventMouseMotion @event){
		Vector2 mouseMovement = @event.Relative;
		stats.xlook += -mouseMovement[0] * stats.ply_xlookspeed;
		stats.ylook += -mouseMovement[1] * stats.ply_ylookspeed;

		stats.xlook = Math.Clamp(stats.xlook, stats.ply_maxlookangle_down, stats.ply_maxlookangle_up);
	}

	public void ViewAngles(){
		camera.Rotation = new Vector3(stats.xlook, stats.ylook,0);
	}

	public void InputKeys(){
		stats.sidemove += stats.ply_sidespeed * ((int)(Input.GetActionStrength("move_left") * 50));
		stats.sidemove -= stats.ply_sidespeed * ((int)(Input.GetActionStrength("move_right") * 50));

		stats.forwardmove += stats.ply_sidespeed * ((int)(Input.GetActionStrength("move_forward") * 50));
		stats.forwardmove -= stats.ply_sidespeed * ((int)(Input.GetActionStrength("move_back") * 50));

		// Clamp that shit so it doesn't go too high
		if (Input.IsActionJustReleased("move_left") || Input.IsActionJustReleased("move_right")){
			stats.sidemove = 0;
		}else{
			stats.sidemove = Math.Clamp(stats.sidemove, -4096, 4096);
		}

		if (Input.IsActionJustReleased("move_forward") || Input.IsActionJustReleased("move_back")){
			stats.upmove = 0;
		}else{
			stats.upmove = Math.Clamp(stats.upmove, -4096, 4096);
		}

		if (Input.IsActionJustReleased("move_forward") || Input.IsActionJustReleased("move_back")){
			stats.forwardmove = 0;
		}else{
			stats.forwardmove = Math.Clamp(stats.forwardmove, -4096, 4096);
		}
		
	}
}


