extends Player_Inputs
class_name Player

@onready var myShape = $CollisionShape3D
@onready var mySkin = $MeshInstance3D
@onready var bonker = $Headbonk
@onready var spring = $TwistPivot/PitchPivot
@onready var coyoteTimer = $CoyoteTime



var height = 2 #the model is 2 meter tall


func _ready():
	camera = get_node(stats.camPath)
	
	stats.on_floor = false

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
	
	
	if stats.wasOnFloor && !stats.on_floor:
		print("start timer")
		coyoteTimer.start()
	
	if(stats.on_floor):
		stats.shouldJump = true
	else:
		if coyoteTimer.is_stopped():
			stats.shouldJump = false
			#print("timer stopped")
			pass
	
	
		


func CheckVelocity():
	# bound velocity
	# Bound it.
	if stats.vel.length() > stats.ply_maxvelocity:
		stats.vel = stats.ply_maxvelocity

	elif stats.vel.length() < -stats.ply_maxvelocity:
		stats.vel = -stats.ply_maxvelocity



		

## Perform a move-and-slide along the set velocity vector. If the body collides
## with another, it will slide along the other body rather than stop immediately.
## The method returns whether or not it collided with anything.
func move_and_slide_own() -> bool:
	var collided := false

	# Reset previously detected floor
	stats.on_floor  = false


	#check floor
	var checkMotion := velocity * get_delta_time()
	checkMotion.y  -= stats.ply_gravity * get_delta_time()
		
	var testcol := move_and_collide(checkMotion, true)
	#print(testcol)
	if testcol:
		var testNormal = testcol.get_normal()
		if testNormal.angle_to(up_direction) < stats.ply_maxslopeangle:
			stats.on_floor = true

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
