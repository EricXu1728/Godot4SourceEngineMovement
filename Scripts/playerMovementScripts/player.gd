extends Player_Inputs
class_name Player

@onready var myShape = $CollisionShape3D
@onready var mySkin = $MeshInstance3D
@onready var bonker = $Headbonk
@onready var spring = $TwistPivot/PitchPivot



var height = 2 #the model is 2 meter tall


func _ready():
	stats.on_floor = false
	stats.camera = $TwistPivot #CHANGE WHEN YOU WANT TO MESS WITH CAMERA
	spring.add_excluded_object(self.get_rid())
	

# warning-ignore:unused_argument
func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		InputKeys()
		
		ViewAngles(delta)
	
	stats.snap = -get_floor_normal()

	stats.wasOnFloor = stats.on_floor


	
	velocity = stats.vel
	move_and_slide_own()
	stats.vel = velocity
	
	

func CheckVelocity():
	# bound velocity
	# Bound it.
	if stats.vel.length() > stats.ply_maxvelocity:
		stats.vel = stats.ply_maxvelocity

	elif stats.vel.length() < -stats.ply_maxvelocity:
		stats.vel = -stats.ply_maxvelocity


func CrouchCamera():

	# Crouching
	if stats.crouching:
		stats.crouched = true
	if !stats.crouching:
		stats.crouched = false


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
		
		

## Perform a move-and-slide along the set velocity vector. If the body collides
## with another, it will slide along the other body rather than stop immediately.
## The method returns whether or not it collided with anything.
func move_and_slide_own() -> bool:
	var collided := false

	# Reset previously detected floor
	stats.on_floor  = false
	
	
	#check for floor
	var checkMotion := velocity * get_delta_time()
	checkMotion.y  -= stats.ply_gravity * get_delta_time()
	
	var testcol := move_and_collide(checkMotion, true)
	if testcol:
#		print(testcol)
		var normal = testcol.get_normal()
		if normal.angle_to(up_direction) < stats.ply_maxslopeangle:
			stats.on_floor = true
		pass



	# Loop performing the move
	var motion := velocity * get_delta_time()
	
	
	for step in max_slides:
		
		var collision := move_and_collide(motion)
		
		
		if not collision:
			# No collision, so move has finished
		
			break

		# Calculate velocity to slide along the surface
	
		var normal = collision.get_normal()
		
		motion = collision.get_remainder().slide(normal)
		velocity = velocity.slide(normal)
	

		# Collision has occurred
		collided = true


	return collided

func get_delta_time() -> float:
	if Engine.is_in_physics_frame():
		return get_physics_process_delta_time()

	return get_process_delta_time()
