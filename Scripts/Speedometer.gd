extends RichTextLabel
@export var stats : Resource
var speed = 0
var yOrigin = 0
var xOrigin = 0
var yOriginSize = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	xOrigin = self.position.x
	yOrigin = self.position.y
	yOriginSize = self.size.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	speed = (speed + stats.vel.length())/2
	text = "Speed: "+ str(snapped(speed,0.1)) + " m/s"
	
	var newscale = (pow(speed,0.4)/3)-0.2
	newscale = clamp(newscale, 1, 5)
	
	var range_ = clamp(newscale -1, 0, 5)
	var randomx = rng.randf_range(-range_, range_)
	var randomy = rng.randf_range(-range_, range_)
	
	self.position.y = yOrigin+((1-(newscale))*yOriginSize) + randomy
	self.position.x = xOrigin + randomx
	
	
	
	
	self.scale.x = newscale
	self.scale.y = newscale
	
	#print(Color.YELLOW)
	#print(Color.ORANGE)
	#print(Color.RED)
	
	var blue = clamp(2-(newscale), 0, 1)
	var green = clamp(2.3-(newscale), 0, 1)
	
	
	self.modulate = Color(1,green,blue,1)
	pass
