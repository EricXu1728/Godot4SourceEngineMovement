# Run.gd
extends PlayerState

func enter(_msg := {}) -> void:
	print("run")
	
func physics_update(delta: float) -> void:
	Move(delta)


func Move(delta):
	#you would normaly have a check to see if velocity is too high and set to "air" to mimic source, but this feels better
	if player.stats.on_floor and player.stats.noclip == false:
		WalkMove(delta)
	else:
		state_machine.transition_to("Air")

	if Input.is_action_pressed("jump"):

		state_machine.transition_to("Air", {do_jump = true})

	player.CheckVelocity()


func WalkMove(delta):
	var forward = Vector3.FORWARD
	var side = Vector3.LEFT

	forward = forward.rotated(Vector3.UP, player.stats.camera.rotation.y)
	side = side.rotated(Vector3.UP, player.stats.camera.rotation.y)

	forward = forward.normalized()
	side = side.normalized()



	#print("wow2"+ str(forwardmove))
	var fmove = player.stats.forwardmove
	var smove = player.stats.sidemove

	var wishvel = side * smove + forward * fmove

	Friction(delta)

	# Zero out y value
	wishvel.y = 0

	var wishdir = wishvel.normalized()
	# VectorNormalize in the original source code doesn't actually return the length of the normalized vector
	# It returns the length of the vector before it was normalized
	var wishspeed = wishvel.length()


	#print("wow3: "+str(wishspeed))
	# clamp to game defined max speed
	if wishspeed != 0.0 and wishspeed > player.speed:
		#print("wishvel")
		#print(wishvel)
		wishvel *= player.speed / wishspeed
		wishspeed = player.speed
		#print(wishvel)

	#print("wow4: "+str(wishspeed))

	Accelerate(wishdir, wishspeed, player.stats.ply_accelerate, delta)


func Accelerate(wishdir, wishspeed, accel, delta):
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

	for i in range(3):
		# Adjust velocity.
		player.stats.vel += accelspeed * wishdir

	#reduce straifing on ground


func Friction(delta):
	# If we are in water jump cycle, don't apply friction
	#if (player->m_flWaterJumpTime)
	#	return

	# Calculate speed
	var speed = player.stats.vel.length()

	# If too slow, return
	if speed < 0:
		return

	var drop = 0

	# apply ground friction
	var friction = player.stats.ply_friction

	# Bleed off some speed, but if we have less than the bleed
	#  threshold, bleed the threshold amount.
	var control = player.stats.ply_stopspeed if speed < player.stats.ply_stopspeed else speed
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
		player.stats.vel *= newspeed





	
