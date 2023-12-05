extends Node
@onready var timer = $Timer
@onready var sprite = $particleSprite

# Called when the node enters the scene tree for the first time.

func _ready():
	sprite.modulate.a =0.8
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scale.x += 10. *delta
	self.scale.y += 10. *delta
	sprite.modulate.a *= 0.9
	
	if timer.is_stopped():
		queue_free()
		#print("timer")
	pass

func set_scale(newScale : Vector2) -> void:
	#print(sprite)
	#print(self.scale.xy)
	self.scale.x = newScale.x
	self.scale.y = newScale.y
	
	
#Do not use this on frame it is created
func set_modulate(color : Color):
	
	sprite.modulate = color
