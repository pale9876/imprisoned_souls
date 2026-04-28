@tool
extends Endeka


var field: FlowField = FlowField.new()


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		field.create(Vector2i(640, 360))
		field.set_cell_height(Vector2i(1, 1), 1.)
		field.get_low(Vector2i(2, 2))
