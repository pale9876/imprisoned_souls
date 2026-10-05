extends Node2D



func apply_force(force: Vector2, hit_point: Vector2) -> void:
	for idx: int in get_child_count():
		var node := get_child(idx)
		if node is RigidBody2D:
			var force_ratio: float = (idx + 1 / 2.) / (float(get_child_count()) / 2.)
			node.apply_force(force * force_ratio, hit_point)


func apply_torque(hit_point: Vector2, force: Vector2) -> void:
	for idx: int in get_child_count():
		var node := get_child(idx)
		if node is RigidBody2D:
			node.apply_torque(force.length())


	
