@tool
class_name PhysicsBall
extends PhysicsEntity

func update_properties():
	super.update_properties()
	if 'size' in properties:
		$MeshInstance.mesh.radius = properties.size * 0.5
		$MeshInstance.mesh.height = properties.size

		$CollisionShape.shape.radius = properties.size * 0.5


func use():
	bounce()

func bounce():
	linear_velocity.y = 10
