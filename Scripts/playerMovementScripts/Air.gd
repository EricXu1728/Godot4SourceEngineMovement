# Air.gd
extends PlayerState


# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	print("AIR")
	if msg.has("do_jump"):
		CheckJumpButton()

func physics_update(delta: float) -> void:
	AirMove(delta)


	if stats.on_floor && abs(player.velocity.y)<15:
		
	
		state_machine.transition_to("Run")


func AirMove(delta):

	var forward = Vector3.FORWARD
	var side = Vector3.LEFT

	forward = forward.rotated(Vector3.UP, stats.camera.rotation.y)
	side = side.rotated(Vector3.UP, stats.camera.rotation.y)

	forward = forward.normalized()
	side = side.normalized()
	
	stats.vel.y -= stats.ply_gravity * delta

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

	if not (stats.on_floor) ||  player.velocity.y>15:
			return

	var flGroundFactor = 1.0
	
	
	var flMul : float
	
	if stats.crouching: #trying to emulate that crouch jumping is slightly higher than jump crouching but not completely accurate
		flMul = sqrt(2 * (stats.ply_gravity*1.1) * stats.ply_jumpheight)
		
		player.move_and_collide(Vector3(0, 2-player.myShape.scale.y, 0))
		
		
		
	else:
		flMul = sqrt(2 * stats.ply_gravity * stats.ply_jumpheight)
	
	
	stats.vel.y += flGroundFactor * flMul  + max(0, stats.vel.y)# 2 * gravity * height
	#print(stats.vel.y)
