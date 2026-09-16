@tool
extends Control


@export var offset_ratio: float = .75


func _draw() -> void:
	if !Engine.is_editor_hint(): return
	
	# draw center x
	var center_x: float = size.x / 2.
	var grid_y: float = size.y * offset_ratio
	
	draw_line(
		Vector2(center_x, 0.),
		Vector2(center_x, grid_y),
		Color.WHITE,
	)

	draw_line(
		Vector2(0., grid_y),
		Vector2(size.x, grid_y),
		Color.WHITE
	)


func get_enter_btn() -> Button:
	return get_node("%Enter") as Button
