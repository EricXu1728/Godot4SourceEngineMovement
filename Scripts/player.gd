extends "res://Scripts/player_inputs.gd"


func _ready():
	stats.camera = $TwistPivot #CHANGE WHEN YOU WANT TO MESS WITH CAMERA
	print("AMONGUS")
	print(stats.camera)
	
	if(stats.camera == null):
		print("BRUH")
	

# warning-ignore:unused_argument
func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		InputKeys()
		
		ViewAngles(delta)
		#print("working")
		
			
	Move(delta)
	CrouchCamera()
	stats.wasOnFloor = is_on_floor()
	
	velocity = stats.vel
	move_and_slide()
	stats.vel = velocity
	


	
func CheckVelocity():
	# bound velocity
	# Bound it.
	if stats.vel.length() > stats.ply_maxvelocity:
		stats.vel = stats.ply_maxvelocity
			
	elif stats.vel.length() < -stats.ply_maxvelocity:
		stats.vel = -stats.ply_maxvelocity

func Move(delta):
	if stats.noclip == true:
		NoclipMove(delta)
		
	elif is_on_floor() and stats.noclip == false:
		WalkMove(delta)
	else:
		AirMove(delta)
	
	if Input.is_action_pressed("jump"):
		
		CheckJumpButton()
		
	CheckVelocity()
	
	#print("wow1" + str(vel))
	
	
func CrouchCamera():
	
	# Crouching
	if stats.crouching:
		stats.crouched = true
	if !stats.crouching:
		stats.crouched = false
	
	
func WalkMove(delta):
	var forward = Vector3.FORWARD
	var side = Vector3.LEFT
	
	forward = forward.rotated(Vector3.UP, stats.camera.rotation.y)
	side = side.rotated(Vector3.UP, stats.camera.rotation.y)
	
	forward = forward.normalized()
	side = side.normalized()
	
	stats.snap = -get_floor_normal()
	
	#print("wow2"+ str(forwardmove))
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
	
	
	#print("wow3: "+str(wishspeed))
	# clamp to game defined max speed
	if wishspeed != 0.0 and wishspeed > stats.ply_maxspeed:
		#print("wishvel")
		#print(wishvel)
		wishvel *= stats.ply_maxspeed / wishspeed
		wishspeed = stats.ply_maxspeed
		#print(wishvel)
		
	#print("wow4: "+str(wishspeed))
	
	Accelerate(wishdir, wishspeed, stats.ply_accelerate, delta)
	
	
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
	stats.vel.y -= stats.ply_gravity * delta
	
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
	
	AirAccelerate(wishdir, wishspeed, stats.ply_airaccelerate, delta)
	
	
func NoclipMove(delta):
	var forward = Vector3.FORWARD
	var side = Vector3.LEFT
	var up = Vector3.UP
	
	forward = forward.rotated(Vector3.UP, stats.camera.rotation.y)
	side = side.rotated(Vector3.UP, stats.camera.rotation.y)
	
	forward = forward.normalized()
	side = side.normalized()
	
	var fmove = stats.forwardmove
	var smove = stats.sidemove
	var umove = stats.xlook
	
	var wishvel = side * smove + forward * fmove
	if fmove != 0:
		wishvel.y += stats.camera.rotation_degrees.x * 50
	
	var wishdir = wishvel.normalized()
	# VectorNormalize in the original source code doesn't actually return the length of the normalized vector
	# It returns the length of the vector before it was normalized
	var wishspeed = wishvel.length()
	
	# clamp to game defined max speed
	if wishspeed != 0.0 and wishspeed > stats.ply_maxspeed:
		
		wishvel *= stats.ply_maxspeed / wishspeed
		wishspeed = stats.ply_maxspeed
		
		
	Friction(delta)
	
	Accelerate(wishdir, wishspeed, stats.ply_maxacceleration, delta)

	$top.set_disabled(true)
	$bottom.set_disabled(true)
	
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
	
func Friction(delta):
	# If we are in water jump cycle, don't apply friction
	#if (player->m_flWaterJumpTime)
	#	return

	# Calculate speed
	var speed = stats.vel.length()
	
	# If too slow, return
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
	#print("STEP")
	#print("should have stopped: " +str(!coyote_timer.is_stopped()))
	if not (is_on_floor()):
			return
	#print("I JUMPED")
	
	var flGroundFactor = 1.0
	var flMul = sqrt(2 * stats.ply_gravity * stats.ply_jumpheight)
	stats.vel.y = flGroundFactor * flMul  + max(0, stats.vel.y)# 2 * gravity * height
	
	
