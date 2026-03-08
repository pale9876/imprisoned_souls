@tool
extends BTPlayer
class_name ActionBTPlayer


signal state_changed(str: String)



var _state: String = "Idle"
var target: Node2D = null



func get_target() -> Node2D: return target

func change_state(str: String) -> void:
	_state = str
	state_changed.emit(str)
