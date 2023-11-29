extends Node3D

@export var stats : playerVariables
@onready var decal = $Shadowarm/Node3D/Decal
@export var ignore : Node3D
@onready var shadowArm = $Shadowarm


# Called when the node enters the scene tree for the first time.
func _ready():
	shadowArm.add_excluded_object(ignore.get_rid())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(stats.vel)
	decal.position.z = -stats.vel.y * delta
	decal.scale.y = 1 + abs(-stats.vel.y *delta *2)
	#print(decal.scale.y)
	pass
