# Air.gd
extends PlayerState


# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	print("AIR")
	stats.on_floor = false
	if msg.has("do_jump"):
		CheckJumpButton()

func physics_update(delta: float) -> void:
	AirMove(delta)
	

	

	if stats.on_floor && abs(player.velocity.y)<15:
		
		state_machine.transition_to("Run")
	else:
		if(Input.is_action_pressed("jump")):
			CheckJumpButton()


func AirMove(delta):

	var forward = Vector3.FORWARD
	var side = Vector3.LEFT

	forward = forward.rotated(Vector3.UP, stats.camera.rotation.y)
	side = side.rotated(Vector3.UP, stats.camera.rotation.y)

	forward = forward.normalized()
	side = side.normalized()
	

	var fmove = stats.forwardmove
	var smove = stats.sidemove

	stats.snap = Vector3.ZERO

	var wishvel = side * smove + forward * fmove

	# Zero out y value
	wishvel.y = 0

	var wishdir = wishvel.normalized()
	# VectorNormalize in the original source code doesn't actually return the length of the normalized vector
	# It returns the length of the vector before it was normalized
	var wishspeed = wishvel.length()
	

	# clamp to game defined max speed
	if wishspeed != 0.0 and wishspeed > stats.ply_maxspeed:
		wishvel *= stats.ply_maxspeed / wishspeed
		wishspeed = stats.ply_maxspeed
	#print(stats.ply_airaccelerate, " ", stats.ply_airspeedcap)
	AirAccelerate(wishdir, wishspeed, stats.ply_airaccelerate, delta)
	player.CheckVelocity()

func AirAccelerate(wishdir, wishspeed, accel, delta):
	# cap speed
	wishspeed = min(wishspeed, stats.ply_airspeedcap)
	# See if we are changing direction a bit
	var currentspeed = stats.vel.dot(wishdir)
	# Reduce wishspeed by the amount of veer.
	var addspeed = wishspeed - currentspeed

	# If not going to add any speed, done.
	if addspeed <= 0:
		return

	# Determine amount of accleration.
	var accelspeed = accel * wishspeed * delta 
	# Cap at addspeed
	accelspeed = min(accelspeed, addspeed)
	

	for i in range(3):
		# Adjust velocity.
		stats.vel += accelspeed * wishdir



func CheckJumpButton():
	
	
	stats.snap = Vector3.ZERO

	if not (stats.shouldJump) ||  player.velocity.y>15:
		return

	stats.shouldJump = false
	
	
	var flGroundFactor = 1.0
	
	
	var flMul : float
	
	
	flMul = sqrt(2 * stats.ply_gravity * stats.ply_jumpheight)
	
	var jumpvel =  flGroundFactor * flMul  + max(0, stats.vel.y)# 2 * gravity * height
	
	stats.vel.y = max(jumpvel, jumpvel + stats.vel.y)
	print("Coyote jump: ",stats.vel.y)
