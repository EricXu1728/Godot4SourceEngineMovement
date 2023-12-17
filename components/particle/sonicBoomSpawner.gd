extends Node3D

@export var stats : Resource
var nextEmit = 0
var base : Node3D
@export var point : Node3D
var rng = RandomNumberGenerator.new()
var scene_trs =load("res://components/particle/burstParticle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	base = get_tree().root.get_node("Level")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stats.vel.length()>40:
		nextEmit += pow(stats.vel.length(),1.6)

	if(nextEmit>20000):
		nextEmit-=20000
		
		var pitch = pow(clamp((stats.vel.length()/40)-2, 1, 2),3)
		
		#print(pitch)
		$AudioStreamPlayer.pitch_scale = pitch
		$AudioStreamPlayer.volume_db = -pow(stats.vel.length()/40,2)
		$AudioStreamPlayer.play()
		
		spawnSonic((stats.vel*delta * 1))
		
	pass

func spawnSonic(plusPosition := Vector3.ZERO, partScale := Vector2(1,1)) -> Node3D:
	
	var scene=scene_trs.instantiate()
		
	scene.position = point.position + plusPosition
	scene.position.y +=1
		
	scene.rotation.y = atan2(stats.vel.x, stats.vel.z)
	var speedVec = Vector2(stats.vel.x, stats.vel.z)
	var my_random_number = rng.randf_range(0.0, 360.0)
	scene.rotation.z = my_random_number

	scene.rotation.x = atan2(speedVec.length(), stats.vel.y)-(PI/2)
		
	scene.set_scale(partScale)
	
	base.add_child(scene)
		
	return scene
