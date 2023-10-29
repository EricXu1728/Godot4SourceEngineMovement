extends "res://Scripts/player_inputs.gd"

@export var moveComponent : MoveComponent

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
	
	stats.snap = -get_floor_normal()
	stats.on_floor = is_on_floor()
	moveComponent.Move(delta)
	
	velocity = stats.vel
	move_and_slide()
	stats.vel = velocity
	


	
