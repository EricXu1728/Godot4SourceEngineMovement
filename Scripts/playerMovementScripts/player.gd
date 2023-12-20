extends PlayerInputs
class_name Player

@onready var myShape = $CollisionShape3D
@onready var mySkin = $Sprite3D
@onready var bonker = $Headbonk
@onready var spring = $TwistPivot/PitchPivot
@onready var coyoteTimer = $CoyoteTime
@onready var view = $TwistPivot/PitchPivot/view




var height = 2 #the model is 2 meter tall


func _ready():
	
	mySkin.set_sorting_offset(1)
	#get_viewport().get_camera_3d()
	camera = get_node(stats.camPath)
	print(stats.vel)
	
	stats.on_floor = false
	spring.add_excluded_object(self.get_rid())
	
	

var frame = 0
var nextEmit = 0

func _process(delta):
	
	view.fov = clamp(70+sqrt(stats.vel.length()*7),90, 180)
	spring.spring_length = clamp(4+(sqrt(stats.vel.length())/1.5),8, 100)
	
	if frame>=10:
		mySkin.frame = 0
		frame = 0
	mySkin.frame = round(frame)
	$Sprite3D/color.frame = round(frame)
	#print(mySkin.frame)
	frame+= stats.vel.length() * delta * 0.6
	
		
	mySkin.rotation.y = camera.rotation.y
	mySkin.rotation.x = (camera.rotation.x)/2

			
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
	
	
		
func clearCoyote():
	coyoteTimer.stop()
	stats.shouldJump = false
	stats.on_floor = false

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
	var checkMotion := velocity * (1/60.)
	checkMotion.y  -= stats.ply_gravity * (1/360.)
		
	var testcol := move_and_collide(checkMotion, true)

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
