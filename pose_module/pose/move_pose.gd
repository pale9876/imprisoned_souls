@tool
extends Pose
class_name Move



func enter(_data: Dictionary[String, Variant] = {}) -> void:
	pass


func tick(delta: float) -> void:
	var unit: Unit = instance_from_id(module.owner)
	
	if unit is Player:
		var input: Vector2 = Input.get_vector("left", "right", "up", "down")
		
		if input != Vector2():
			unit.velocity = unit.velocity.move_toward(
				input * unit.stat.speed, unit.unit_information.acceleration * delta
			)
			unit.move(unit.velocity, delta)
		else:
			change_pose("idle")
