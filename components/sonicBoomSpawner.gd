extends Node3D

@export var stats : playerVariables
var nextEmit = 0
var base : Node3D
@export var point : Node3D

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
		var scene_trs =load("res://components/customParticle.tscn")
		var scene=scene_trs.instantiate()
		
		scene.position = point.position + (stats.vel*delta)
		scene.position.y +=1
		
		scene.rotation.y = atan2(stats.vel.x, stats.vel.z)
		var speedVec = Vector2(stats.vel.x, stats.vel.z)

		scene.rotation.x = atan2(speedVec.length(), stats.vel.y)-(PI/2)
		
		base.add_child(scene)
	pass
