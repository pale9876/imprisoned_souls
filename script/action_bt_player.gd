@tool
extends BTPlayer


var _state: String = "Idle"
var target: Node2D = null


func _enter_tree() -> void:
	agent_node


func get_target() -> Node2D: return target
func change_state(str: String) -> void: _state = str
