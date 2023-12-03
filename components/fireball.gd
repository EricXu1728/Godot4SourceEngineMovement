extends Node3D

@export var stats: playerVariables

@onready var fireball :=$fireball
@onready var camera : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.scale.x = 10
	$Label.scale.y = 10
	#camera = get_viewport().get_camera_3d()
	pass # Replace with function body.

#var time = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(!Input.is_action_pressed("crouch")):
		rotation.y = atan2(stats.vel.x, stats.vel.z) + (PI/2)
		var speedVec := Vector2(stats.vel.x, stats.vel.z)
		rotation.z =  atan2(speedVec.length(), stats.vel.y) + (PI/2)
	
	var compareRot = deg_to_rad(stats.ylook) - rotation.y
	
	#compareRot = fmod(abs(compareRot), (2* PI)) -PI
	
	#print(compareRot)
	while(compareRot>(PI)):
		compareRot -= (2 * PI)
		
	while(compareRot<(-PI)):
		compareRot += (2 * PI)
	#print(str(stats.ylook) )
	
	var margin = (PI/3)
	if(compareRot > ((PI/2)-margin)) && (compareRot < ((PI/2)+margin)):
		$Label.text = "Yep"
		var count = 0
		for _i in fireball.get_children():
			#print(_i)
			_i.set_sorting_offset(-30+count)
			count +=1
	else:
		$Label.text = "Nope"
		var count = 0
		for _i in fireball.get_children():
			_i.set_sorting_offset(30+(count*5))
			count +=1
		

	fireball.scale.x = pow(stats.vel.length(), 0.4)
	var otherScale =  pow(stats.vel.length(), 0.1)
	fireball.scale.y = otherScale
	fireball.scale.z = otherScale
	#time +=0.01
	
	#test.set_sorting_offset(sin(time))
	#print(test.get_sorting_offset())
	
	#fireball.scale.x =3#+=0.01
	pass
