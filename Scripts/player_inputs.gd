extends "res://Scripts/player_vars.gd"
#CODE THAT PARSES USER INPUT
#just organized like this for organization's sake


func _ready():
	assert("You should not be seeing this (player_inputs.gd is being initiated)")
	
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		InputMouse(event)
		
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func InputMouse(event):
	xlook += -event.relative.y * ply_xlookspeed 
	ylook += -event.relative.x * ply_ylookspeed
	xlook = clamp(xlook, ply_maxlookangle_down, ply_maxlookangle_up)
	
func ViewAngles(delta):
	camera.rotation_degrees.x = xlook
	camera.rotation_degrees.y = ylook
	
func InputKeys():
	sidemove += int(ply_sidespeed) * (int(Input.get_action_strength("move_left") * 50))
	sidemove -= int(ply_sidespeed) * (int(Input.get_action_strength("move_right") * 50))
	#print(Input.get_action_strength("move_left"))
	
	forwardmove += int(ply_forwardspeed) * (int(Input.get_action_strength("move_forward") * 50))
	forwardmove -= int(ply_backspeed) * (int(Input.get_action_strength("move_back") * 50))
	
	# Clamp that shit so it doesn't go too high
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		sidemove = 0
	else:
		sidemove = clamp(sidemove, -4096, 4096)
		
	if Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_back"):
		upmove = 0
	else:
		upmove = clamp(upmove, -4096, 4096)
	if Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_back"):
		forwardmove = 0
	else:
		forwardmove = clamp(forwardmove, -4096, 4096)
		
	#print(forwardmove)
	

	

