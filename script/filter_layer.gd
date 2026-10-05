@tool
extends CanvasLayer
class_name FilterLayer


@export var _toggle: bool = true:
	set(toggle):
		_toggle = toggle
		if Engine.is_editor_hint() and is_node_ready():
			get_filter_rect().visible = toggle


func get_game_viewport() -> MainHeirViewport:
	return get_container().get_node(^"%GameViewport")


func get_container() -> SubViewportContainer:
	return get_node(^"SubViewportContainer") as SubViewportContainer


func get_filter_rect() -> ColorRect:
	return get_node(^"FilterRect") as ColorRect


	
