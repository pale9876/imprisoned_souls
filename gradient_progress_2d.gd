@tool
extends GradientProgress2D


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()
		await get_tree().create_timer(1.).timeout
		change_value(0.)
