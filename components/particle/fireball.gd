extends Node3D

@export var stats: playerVariables
@onready var fireball :=$fireball
@onready var camera : Camera3D
@onready var layers := [$fireball/Sphere, $fireball/Yellow, $fireball/White]
var state := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	updateRot()
	
	fireball.scale.x = pow(stats.vel.length(), 0.4)
	var otherScale =  pow(stats.vel.length(), 0.1)
	fireball.scale.y = otherScale
	fireball.scale.z = otherScale
	
	
	
	pass
	
func updateRot():
	rotation.y = atan2(stats.vel.x, stats.vel.z) + (PI/2)
	var speedVec := Vector2(stats.vel.x, stats.vel.z)
	rotation.z =  atan2(speedVec.length(), stats.vel.y) + (PI/2)
	
	var compareRot = deg_to_rad(stats.ylook) - rotation.y
	
	compareRot = wrapf(compareRot, -PI, PI)
	
	var margin = (PI/3)
	if(compareRot > ((PI/2)-margin)) && (compareRot < ((PI/2)+margin)):
		var count = 0
		for _i in fireball.get_children():
			_i.set_sorting_offset(-30+count)
			count +=1
	else:
		var count = 0
		for _i in fireball.get_children():
			_i.set_sorting_offset(30+(count*5))
			count +=1

	
