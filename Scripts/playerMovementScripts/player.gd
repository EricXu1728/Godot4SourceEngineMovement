extends Player_Inputs
class_name Player

@onready var myShape = $CollisionShape3D
@onready var mySkin = $MeshInstance3D
@onready var bonker = $Headbonk
@onready var spring = $TwistPivot/PitchPivot


var height = 2 #the model is 2 meter tall
@onready var speed = stats.ply_maxspeed

func _ready():
	stats.on_floor = false
	stats.camera = $TwistPivot #CHANGE WHEN YOU WANT TO MESS WITH CAMERA
	print("AMONGUS")
	print(stats.camera)
	spring.add_excluded_object(self.get_rid())
	
	if(stats.camera == null):
		print("BRUH")
	

# warning-ignore:unused_argument
func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		InputKeys()
		
		ViewAngles(delta)
	
	stats.snap = -get_floor_normal()

	stats.wasOnFloor = stats.on_floor


	stats.vel.y -= stats.ply_gravity * delta
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


	# Loop performing the move

	
	var motion := velocity * get_delta_time()
	#print(motion)
	
	for step in max_slides:
		
		var collision := move_and_collide(motion)
		
		
		#test stuff
		
		
		#end test stuff
		
		
		
		if not collision:
			# No collision, so move has finished
		
			break

		# Calculate velocity to slide along the surface
		
		var normal = collision.get_normal()
		
		motion = collision.get_remainder().slide(normal)
		#print("motion ", motion)
		velocity = velocity.slide(normal)
		
		
		# Check for the floor
		
	
		if normal.angle_to(up_direction) < floor_max_angle:
			stats.on_floor = true
	

		# Collision has occurred
		collided = true


	return collided

func get_delta_time() -> float:
	if Engine.is_in_physics_frame():
		return get_physics_process_delta_time()

	return get_process_delta_time()
