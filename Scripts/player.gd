extends "res://Scripts/player_inputs.gd"


func _ready():
	camera = $TwistPivot #CHANGE WHEN YOU WANT TO MESS WITH CAMERA
	print("AMONGUS")
	print(camera)
	
	if(camera == null):
		print("BRUH")
	

# warning-ignore:unused_argument
func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		InputKeys()
		
		ViewAngles(delta)
		#print("working")
		
			
	Move(delta)
	CrouchCamera()
	wasOnFloor = is_on_floor()
	
	velocity = vel
	move_and_slide()
	vel = velocity
	


	
func CheckVelocity():
	# bound velocity
	# Bound it.
	if vel.length() > ply_maxvelocity:
		vel = ply_maxvelocity
			
	elif vel.length() < -ply_maxvelocity:
		vel = -ply_maxvelocity

func Move(delta):
	if noclip == true:
		NoclipMove(delta)
		
	elif is_on_floor() and noclip == false:
		WalkMove(delta)
	else:
		AirMove(delta)
	
	if Input.is_action_pressed("jump"):
		
		CheckJumpButton()
		
	CheckVelocity()
	
	#print("wow1" + str(vel))
	
	
func CrouchCamera():
	
	# Crouching
	if crouching:
		crouched = true
	if !crouching:
		crouched = false
	
	
func WalkMove(delta):
	var forward = Vector3.FORWARD
	var side = Vector3.LEFT
	
	forward = forward.rotated(Vector3.UP, camera.rotation.y)
	side = side.rotated(Vector3.UP, camera.rotation.y)
	
	forward = forward.normalized()
	side = side.normalized()
	
	snap = -get_floor_normal()
	
	#print("wow2"+ str(forwardmove))
	var fmove = forwardmove
	var smove = sidemove
	
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
	if wishspeed != 0.0 and wishspeed > ply_maxspeed:
		#print("wishvel")
		#print(wishvel)
		wishvel *= ply_maxspeed / wishspeed
		wishspeed = ply_maxspeed
		#print(wishvel)
		
	#print("wow4: "+str(wishspeed))
	
	Accelerate(wishdir, wishspeed, ply_accelerate, delta)
	
	
func AirMove(delta):
	
	var forward = Vector3.FORWARD
	var side = Vector3.LEFT
	
	forward = forward.rotated(Vector3.UP, camera.rotation.y)
	side = side.rotated(Vector3.UP, camera.rotation.y)
	
	forward = forward.normalized()
	side = side.normalized()
	
	var fmove = forwardmove
	var smove = sidemove
	
	snap = Vector3.ZERO
	vel.y -= ply_gravity * delta
	
	var wishvel = side * smove + forward * fmove
	
	# Zero out y value
	wishvel.y = 0
	
	var wishdir = wishvel.normalized()
	# VectorNormalize in the original source code doesn't actually return the length of the normalized vector
	# It returns the length of the vector before it was normalized
	var wishspeed = wishvel.length()
	
	# clamp to game defined max speed
	if wishspeed != 0.0 and wishspeed > ply_maxspeed:
		wishvel *= ply_maxspeed / wishspeed
		wishspeed = ply_maxspeed
	
	AirAccelerate(wishdir, wishspeed, ply_airaccelerate, delta)
	
	
func NoclipMove(delta):
	var forward = Vector3.FORWARD
	var side = Vector3.LEFT
	var up = Vector3.UP
	
	forward = forward.rotated(Vector3.UP, camera.rotation.y)
	side = side.rotated(Vector3.UP, camera.rotation.y)
	
	forward = forward.normalized()
	side = side.normalized()
	
	var fmove = forwardmove
	var smove = sidemove
	var umove = xlook
	
	var wishvel = side * smove + forward * fmove
	if fmove != 0:
		wishvel.y += camera.rotation_degrees.x * 50
	
	var wishdir = wishvel.normalized()
	# VectorNormalize in the original source code doesn't actually return the length of the normalized vector
	# It returns the length of the vector before it was normalized
	var wishspeed = wishvel.length()
	
	# clamp to game defined max speed
	if wishspeed != 0.0 and wishspeed > ply_maxspeed:
		
		wishvel *= ply_maxspeed / wishspeed
		wishspeed = ply_maxspeed
		
		
	Friction(delta)
	
	Accelerate(wishdir, wishspeed, ply_maxacceleration, delta)

	$top.set_disabled(true)
	$bottom.set_disabled(true)
	
func Accelerate(wishdir, wishspeed, accel, delta):
# See if we are changing direction a bit
	var currentspeed = vel.dot(wishdir)
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
		vel += accelspeed * wishdir
		
	#reduce straifing on ground
	
	
	
func AirAccelerate(wishdir, wishspeed, accel, delta):
	# cap speed
	wishspeed = min(wishspeed, ply_airspeedcap)
	# See if we are changing direction a bit
	var currentspeed = vel.dot(wishdir)
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
		vel += accelspeed * wishdir
	
func Friction(delta):
	# If we are in water jump cycle, don't apply friction
	#if (player->m_flWaterJumpTime)
	#	return

	# Calculate speed
	var speed = vel.length()
	
	# If too slow, return
	if speed < 0:
		return

	var drop = 0

	# apply ground friction
	var friction = ply_friction

	# Bleed off some speed, but if we have less than the bleed
	#  threshold, bleed the threshold amount.
	var control = ply_stopspeed if speed < ply_stopspeed else speed
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
		vel *= newspeed

func CheckJumpButton():
	snap = Vector3.ZERO
	#print("STEP")
	#print("should have stopped: " +str(!coyote_timer.is_stopped()))
	if not (is_on_floor()):
			return
	#print("I JUMPED")
	
	var flGroundFactor = 1.0
	var flMul = sqrt(2 * ply_gravity * ply_jumpheight)
	vel.y = flGroundFactor * flMul  + max(0, vel.y)# 2 * gravity * height
	
	
