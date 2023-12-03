extends Sprite3D

const SPEED = 2
var coins = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_sorting_offset(99)
	pass # Replace with function body.

#var time = 0.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#time += 0.0001
	
	
	#print(get_sorting_offset ( ))
	rotate_y(deg_to_rad(SPEED))
	pass
