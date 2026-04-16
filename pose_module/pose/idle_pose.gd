@tool
extends Pose
class_name Idle



func enter(_data: Dictionary[String, Variant] = {}) -> void:
	pass


func tick(delta: float) -> void:
	var unit: Unit = (instance_from_id(module.owner) as Unit)
	
	if unit is Player:
		var input: Vector2 = Input.get_vector("left", "right", "up", "down")
		
		if input != Vector2():
			change_pose("move")
		else:
			if unit.velocity != Vector2():
				unit.velocity = unit.velocity.move_toward(Vector2(), unit.unit_information.friction * delta)
				unit.move(unit.velocity, delta)
