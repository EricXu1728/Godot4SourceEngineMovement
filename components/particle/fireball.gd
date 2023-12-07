extends Node3D

@export var stats: Resource
@export var point : Node3D

@onready var fireball :=$fireball
@onready var camera : Camera3D
@onready var layers := [$fireball/Sphere, $fireball/Yellow, $fireball/White]
@onready var boomSpawner := $sonicBoomSpawner

var state := 0
var breakPoint := [40, 80, 120]
var goal := Vector3.ZERO

var speed_margin := 10
var look_margin := (PI/3)

# Called when the node enters the scene tree for the first time.
func _ready():
	boomSpawner.point = point
	
	fireball.position.x = 1#-1
	for i in layers:
		i.hide()
	$Label.scale = Vector2(10,10)
	fireball.scale = Vector3(0,0,0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	#print(fireball.position.x)
	updateRot()
	
	
	
	var length = stats.vel.length()
	
	$Label.text = str(state)
	fireball.scale = lerp(fireball.scale, goal, max(0.01,15*delta))
	
	match state:
		0:
			if(length>=breakPoint[0]):
				layers[0].show()
				state = 1
				fireball.scale = Vector3(2,2,2)
				fireball.position.x = 1
				
				var boom = boomSpawner.spawnSonic((stats.vel*delta * 12)    , Vector2(3,3))
				boom.set_modulate(Color.ORANGE)
				
		1:
			goal.x = 0.7 + ((length - breakPoint[0])*0.03)
			goal.y = 0.7 + ((length - breakPoint[0])*0.015)
			goal.z = goal.y
			
			
			if(length<(breakPoint[0]-speed_margin)):
				fireball.position.x = 1
				state = 0
				layers[0].hide()
				#fireball.scale = Vector3(0,0,0)
				goal = fireball.scale
			
			if(length>=breakPoint[1]):
				fireball.scale = Vector3(3,3,3)
				layers[1].show()
				state = 2
				fireball.position.x = 2
				
				var boom = boomSpawner.spawnSonic((stats.vel*delta * 12)    , Vector2(3,3))
				boom.set_modulate(Color.YELLOW)
				
		2:
			goal.x = 2 + ((length - breakPoint[1])*0.03)
			goal.y = 1.4 + ((length - breakPoint[1])*0.015)
			goal.z = goal.y
			
			if(length<(breakPoint[1]-speed_margin)):
				fireball.position.x = 1
				layers[1].hide()
				state = 1
			
			if(length>=breakPoint[2]):
				fireball.scale = Vector3(4,4,4)
				layers[2].show()
				state = 3
				
				var boom = boomSpawner.spawnSonic((stats.vel*delta * 12)    , Vector2(3,3))
				boom.set_modulate(Color.RED)
				#boom.velocity = stats.vel/2
				
		3:
			goal.x = 8 + ((length - breakPoint[2])*0.03)
			goal.y = 1.8 + ((length - breakPoint[2])*0.015)
			goal.z = goal.y
			if(length<(breakPoint[2]-speed_margin)):
				
				layers[2].hide()
				state = 2
			
	
	
	pass
	
func updateRot():
	
	
	rotation.y = atan2(stats.vel.x, stats.vel.z) + (PI/2)
	var speedVec := Vector2(stats.vel.x, stats.vel.z)
	rotation.z =  atan2(speedVec.length(), stats.vel.y) + (PI/2)
	
	var compareRot = deg_to_rad(stats.ylook) - rotation.y
	
	compareRot = wrapf(compareRot, -PI, PI)
	
	
	if(compareRot > ((PI/2)-look_margin)) && (compareRot < ((PI/2)+look_margin)):
		var count = 0
		for _i in layers:
			_i.set_sorting_offset(-30+count)
			count +=1
	else:
		var count = 0
		for _i in layers:
			_i.set_sorting_offset(30+(count*5))
			count +=1

	
