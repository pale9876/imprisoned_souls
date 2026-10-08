@tool
extends CanvasLayer
class_name FilterLayer


@export var _toggle: bool = true:
	set(toggle):
		_toggle = toggle
		if is_node_ready():
			toggle_filter(toggle)


func toggle_filter(toggle: bool) -> void:
	var _arr := find_filter_rect()
	for filter: FilterRect in _arr:
		filter.visible = toggle


func get_game_viewport() -> MainHeirViewport:
	return get_container().get_node(^"%GameViewport")


func get_container() -> SubViewportContainer:
	return get_node(^"SubViewportContainer") as SubViewportContainer


func find_filter_rect() -> Array[FilterRect]:
	var arr: Array[FilterRect] = []
	arr.assign(find_children("", "FilterRect", true, false))
	return arr


func get_filter_list() -> Array[StringName]:
	var _result: Array[StringName]
	var _arr := find_filter_rect()
	
	for node: Node in _arr:
		_result.push_back(node.name)

	return _result

#func get_filter_rect() -> FilterRect:
	#return get_node(^"FilterRect") as FilterRect


	
