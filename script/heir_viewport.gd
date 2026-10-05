@tool
extends SubViewport
class_name MainHeirViewport



@export_tool_button("하위 필터 생성", "ColorRect")
var _create_filter: Callable = func() -> void:
	if !Engine.is_editor_hint() and !has_party():
		return
	
	var container := SubViewportContainer.new()
	container.name = &"SubViewportContainer"
	var viewport := MainHeirViewport.new()
	viewport.name = &"GameViewport"
	var rect := FilterRect.new()
	rect.name = &"FilterRect"
	
	self.name = &"MainHeirViewport"
	
	add_child(container)
	container.add_child(viewport)
	add_child(rect)

	var root_node := get_tree().edited_scene_root
	container.owner = root_node
	viewport.owner = root_node
	rect.owner = root_node
	
	container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	move_party(viewport)


func _init() -> void:
	if Engine.is_editor_hint():
		size = get_project_viewport_size()


func get_project_viewport_size() -> Vector2:
	return Vector2(
		ProjectSettings.get("display/window/size/viewport_width"),
		ProjectSettings.get("display/window/size/viewport_height")
	)


func has_party() -> bool:
	return has_node(^"Party")


func move_party(to: Node) -> void:
	var party := get_party()
	party.reparent(to)


func get_party() -> Node:
	return get_node(^"Party")


	
