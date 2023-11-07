# Air.gd
extends PlayerState


# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	print("air")
	if msg.has("do_jump"):
		CheckJumpButton()

func physics_update(delta: float) -> void:
	AirMove(delta)
	if player.is_on_floor():
		#print("huh?")
		#state_machine.transition_to("Idle")
	
		state_machine.transition_to("Run")


func AirMove(delta):

	var forward = Vector3.FORWARD
	var side = Vector3.LEFT

	forward = forward.rotated(Vector3.UP, player.stats.camera.rotation.y)
	side = side.rotated(Vector3.UP, player.stats.camera.rotation.y)

	forward = forward.normalized()
	side = side.normalized()

	var fmove = player.stats.forwardmove
	var smove = player.stats.sidemove

	player.stats.snap = Vector3.ZERO
	player.stats.vel.y -= player.stats.ply_gravity * delta

	var wishvel = side * smove + forward * fmove

	# Zero out y value
	wishvel.y = 0

	var wishdir = wishvel.normalized()
	# VectorNormalize in the original source code doesn't actually return the length of the normalized vector
	# It returns the length of the vector before it was normalized
	var wishspeed = wishvel.length()

	# clamp to game defined max speed
	if wishspeed != 0.0 and wishspeed > player.stats.ply_maxspeed:
		wishvel *= player.stats.ply_maxspeed / wishspeed
		wishspeed = player.stats.ply_maxspeed

	AirAccelerate(wishdir, wishspeed, player.stats.ply_airaccelerate, delta)
	player.CheckVelocity()




func AirAccelerate(wishdir, wishspeed, accel, delta):
	# cap speed
	wishspeed = min(wishspeed, player.stats.ply_airspeedcap)
	# See if we are changing direction a bit
	var currentspeed = player.stats.vel.dot(wishdir)
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
		player.stats.vel += accelspeed * wishdir


func CheckJumpButton():
	player.stats.snap = Vector3.ZERO
	#print("STEP")
	#print("should have stopped: " +str(!coyote_timer.is_stopped()))
	if not (player.stats.on_floor):
			return
	#print("I JUMPED")

	var flGroundFactor = 1.0
	
	
	var flMul : float
	if player.stats.crouching: #trying to emulate that crouch jumping is slightly higher than jump crouching but not completely accurate
		flMul = sqrt(2 * (player.stats.ply_gravity*1.1) * player.stats.ply_jumpheight)
	else:
		flMul = sqrt(2 * player.stats.ply_gravity * player.stats.ply_jumpheight)
	
	
	#print(player.stats.ply_gravity)
	player.stats.vel.y = flGroundFactor * flMul  + max(0, player.stats.vel.y)# 2 * gravity * height
	print(player.stats.vel.y)
