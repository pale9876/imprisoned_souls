@tool
extends Node2D
class_name Map


@export var region: Rect2i = Rect2i(Vector2i(0, 0), Vector2i(2880, 256)):
	set(rect):
		region = rect

@export_category("DEBUG")
@export var debug_color: Color = Color(0.0, 0.91, 0.878, 0.0)
@export var draw_region: bool = false:
	set(toggle):
		draw_region = toggle
		queue_redraw()


func _draw() -> void:
	if draw_region:
		draw_rect(Rect2(region), debug_color, false, 3.)


func get_stage() -> Path2D:
	return get_node("%Stage")
