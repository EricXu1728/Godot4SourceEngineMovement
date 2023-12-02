extends Node
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.

func _ready():
	$particleSprite.modulate.a =0.8
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scale.x += 10. *delta
	self.scale.y += 10. *delta
	$particleSprite.modulate.a *= 0.9
	
	if timer.is_stopped():
		queue_free()
		#print("timer")
	pass
