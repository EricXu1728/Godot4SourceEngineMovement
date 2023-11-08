extends "res://Scripts/player_inputs.gd"
class_name Player

@onready var myShape = $CollisionShape3D
@onready var mySkin = $MeshInstance3D
@onready var bonker = $Headbonk
var height = 2 #the model is 2 meter tall
@onready var speed = stats.ply_maxspeed

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
		
	if Input.is_action_pressed("crouch"):
		myShape.scale.y =0.5

		mySkin.scale.y =0.5
		stats.crouching = true
		speed = stats.ply_crouchspeed
		
		if Input.is_action_just_pressed("crouch"):
			if (stats.on_floor):
				print("was on floor")
				var a = Vector3(0,-10, 0)
				move_and_collide(a)
			else:
				print("woah")
				var a = Vector3(0,1, 0)
				move_and_collide(a)

				stats.camera.position.y = 1
	else:
		if(bonker.is_colliding() == false):
			myShape.scale.y =1
			#stats.camera.position.y += 1
			mySkin.scale.y =1
			stats.camera.position.y =2
			stats.crouching = false
			speed = stats.ply_maxspeed
		
	
		
		
	
	stats.snap = -get_floor_normal()
	stats.on_floor = is_on_floor()
	#Move(delta)
	
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
