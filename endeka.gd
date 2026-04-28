@tool
extends Endeka


var field: FlowField = FlowField.new()


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		field.create(Vector2i(640, 360))
