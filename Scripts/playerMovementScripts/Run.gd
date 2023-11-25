# Run.gd
extends PlayerState

func enter(_msg := {}) -> void:

	print("RUN")
	
func physics_update(delta: float) -> void:
	Move(delta)


func Move(delta):
	#you would normaly have a check to see if velocity is too high and set to "air" to mimic source, but this feels better
	if stats.on_floor:
		WalkMove(delta)
	else:
		print("oh")
		
		state_machine.transition_to("Air")

	if Input.is_action_pressed("jump") && (not stats.crouched) && stats.shouldJump:
		CheckJumpButton()
		
		stats.on_floor = false
		state_machine.transition_to("Air", {do_jump = true})

	player.CheckVelocity()


func WalkMove(delta):
	var forward = Vector3.FORWARD
	var side = Vector3.LEFT

	forward = forward.rotated(Vector3.UP, stats.camera.rotation.y)
	side = side.rotated(Vector3.UP, stats.camera.rotation.y)

	forward = forward.normalized()
	side = side.normalized()
	
	#stats.vel.y -= stats.ply_gravity * delta
	

	var fmove = stats.forwardmove
	var smove = stats.sidemove

	var wishvel = side * smove + forward * fmove

	Friction(delta)

	# Zero out y value
	wishvel.y = 0

	var wishdir = wishvel.normalized()
	# VectorNormalize in the original source code doesn't actually return the length of the normalized vector
	# It returns the length of the vector before it was normalized
	var wishspeed = wishvel.length()


	# clamp to game defined max speed
	if wishspeed != 0.0 and wishspeed > stats.speed:
		wishvel *= stats.speed / wishspeed
		wishspeed = stats.speed
		

	Accelerate(wishdir, wishspeed, stats.ply_accelerate, delta)


func Accelerate(wishdir, wishspeed, accel, delta):
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

	for i in range(3):
		# Adjust velocity.
		stats.vel += accelspeed * wishdir

	#reduce straifing on ground


func Friction(delta):
	# If we are in water jump cycle, don't apply friction
	#if (player->m_flWaterJumpTime)
	#	return

	# Calculate speed
	var speed = stats.vel.length()

	# If too slow, return
	#
	if speed < 0:
		return
		

	var drop = 0

	# apply ground friction
	var friction = stats.ply_friction

	# Bleed off some speed, but if we have less than the bleed
	#  threshold, bleed the threshold amount.
	var control = stats.ply_stopspeed if speed < stats.ply_stopspeed else speed
	# Add the amount to the drop amount.
	drop += control * friction * delta

	# scale the velocity
	var newspeed = speed - drop
	if newspeed < 0:
		newspeed = 0

	if newspeed != speed:
		# Determine proportion of old speed we are using.
		newspeed /= speed
		# Adjust velocity according to proportion.
		stats.vel *= newspeed
		



func CheckJumpButton():
	
	stats.snap = Vector3.ZERO

	if not (stats.shouldJump) ||  player.velocity.y>15:
			return

	stats.shouldJump = false
	var flGroundFactor = 1.0
	
	
	var flMul : float
	
	if stats.crouching: #trying to emulate that crouch jumping is slightly higher than jump crouching but not completely accurate
		flMul = sqrt(2 * (stats.ply_gravity*1.1) * stats.ply_jumpheight)
		
		player.move_and_collide(Vector3(0, 2-player.myShape.scale.y, 0))
		
		
		
	else:
		flMul = sqrt(2 * stats.ply_gravity * stats.ply_jumpheight)
	
	
	var jumpvel =  flGroundFactor * flMul  + max(0, stats.vel.y)# 2 * gravity * height
	
	stats.vel.y = max(jumpvel, jumpvel + stats.vel.y)
	print("nomral jump: ",stats.vel.y)
	
