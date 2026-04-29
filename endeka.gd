@tool
extends Endeka


var field: DetourField = DetourField.new()


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		pass
