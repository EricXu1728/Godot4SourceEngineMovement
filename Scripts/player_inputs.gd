extends CharacterBody3D
#CODE THAT PARSES USER INPUT
#just organized like this for organization's sake
@export var stats: playerVariables

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
	stats.xlook += -event.relative.y * stats.ply_xlookspeed 
	stats.ylook += -event.relative.x * stats.ply_ylookspeed
	stats.xlook = clamp(stats.xlook, stats.ply_maxlookangle_down, stats.ply_maxlookangle_up)
	
func ViewAngles(delta):
	stats.camera.rotation_degrees.x = stats.xlook
	stats.camera.rotation_degrees.y = stats.ylook
	
func InputKeys():
	stats.sidemove += int(stats.ply_sidespeed) * (int(Input.get_action_strength("move_left") * 50))
	stats.sidemove -= int(stats.ply_sidespeed) * (int(Input.get_action_strength("move_right") * 50))
	#print(Input.get_action_strength("move_left"))
	
	stats.forwardmove += int(stats.ply_forwardspeed) * (int(Input.get_action_strength("move_forward") * 50))
	stats.forwardmove -= int(stats.ply_backspeed) * (int(Input.get_action_strength("move_back") * 50))
	
	# Clamp that shit so it doesn't go too high
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		stats.sidemove = 0
	else:
		stats.sidemove = clamp(stats.sidemove, -4096, 4096)
		
	if Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_back"):
		stats.upmove = 0
	else:
		stats.upmove = clamp(stats.upmove, -4096, 4096)
	if Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_back"):
		stats.forwardmove = 0
	else:
		stats.forwardmove = clamp(stats.forwardmove, -4096, 4096)
		
	#print(forwardmove)
	


