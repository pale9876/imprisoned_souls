@tool
extends Label
class_name StateLabel


const FORMAT: String = "State: %s"


func _init() -> void:
	text = FORMAT


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	var hsm := (get_parent() as Unit).get_state_machine()
	
	hsm.active_state_changed.connect(
		func(_current: LimboState, _previous: LimboState) -> void:
			text = FORMAT % String(_current.name)
	)



	
