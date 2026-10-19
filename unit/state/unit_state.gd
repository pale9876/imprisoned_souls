extends DefaultUnitFormState
class_name UnitState



func get_state_machine() -> StateMachine:
	return get_parent() as StateMachine


func take_force(_motion: Vector2) -> KinematicCollision2D:
	var collide: KinematicCollision2D = move_and_collide(_motion)
	return collide


func get_bb_var(var_name: StringName) -> Variant:
	return get_bb().get_var(var_name)


func set_bb_var(var_name: StringName, value: Variant) -> void:
	get_bb().set_var(var_name, value)


func get_bb() -> Blackboard:
	return get_state_machine().get_unit().bt.blackboard


func get_sprite() -> AnimatedSprite2D:
	return get_state_machine().get_unit().get_sprite()


func set_suffix(value: StringName) -> void:
	set_bb_var(&"suffix", value)


func get_suffix() -> StringName:
	var result := get_bb_var(&"suffix") as StringName
	set_bb_var(&"suffix", &"")
	return result
