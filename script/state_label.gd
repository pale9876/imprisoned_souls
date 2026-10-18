@tool
extends Label
class_name StateLabel


const FORMAT: String = "State: %s"


func _init() -> void:
	text = FORMAT


func _enter_tree() -> void:
	var unit := get_parent() as Unit
	unit.get_state_machine().active_state_changed.connect(
		func(current: LimboState, previous: LimboState) -> void:
			text = FORMAT % String(current.name)
	)



	
