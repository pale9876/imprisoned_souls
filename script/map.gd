@tool
extends Node2D
class_name Map


signal state_changed()


@export var state: GlobalClassified.MapState = GlobalClassified.MapState.SAFE:
	set(type):
		state = type

@export var color_variant: Dictionary[GlobalClassified.MapState, Color] = {
	GlobalClassified.MapState.SAFE : Color(0.766, 0.929, 0.97, 1.0),
	GlobalClassified.MapState.ALERT : Color(1.0, 0.744, 0.27, 1.0),
	GlobalClassified.MapState.DANGER : Color(1.0, 0.41, 0.41, 1.0),
	GlobalClassified.MapState.BATTLE : Color(1.0, 0.0, 0.017, 1.0),
	GlobalClassified.MapState.EVENT : Color(0.36, 0.296, 0.4, 1.0),
}

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


func change_state(_state: int) -> void:
	state = _state as GlobalClassified.MapState
	state_changed.emit()


func get_state_color() -> Color:
	if color_variant.has(state):
		return color_variant[state]

	return Color.WHITE
