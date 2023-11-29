extends Node
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
func _ready():
	var my_random_number = rng.randf_range(0.0, 360.0)
	self.rotation.z = my_random_number
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scale.x += 10. *delta
	self.scale.y += 10. *delta
	
	if timer.is_stopped():
		queue_free()
		#print("timer")
	pass
