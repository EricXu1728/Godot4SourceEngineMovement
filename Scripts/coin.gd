extends Area3D


func _ready():
	print("cointime")
	pass



func _on_body_entered(body):
	print("Coined")
	queue_free()
	pass # Replace with function body.
