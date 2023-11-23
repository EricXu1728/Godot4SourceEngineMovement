extends PlayerState


# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	print("standing")
	stats.crouching = false
	stats.crouched = false
	stats.speed = stats.ply_maxspeed
	player.mySkin.scale.y = 1
	player.myShape.scale.y = 1
	
	
func physics_update(delta: float) -> void:
	if(Input.is_action_just_pressed("crouch")):
		state_machine.transition_to("Crouching")
		
