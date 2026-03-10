@tool
extends Control
class_name SlideTextureRect


const NOTIFICATION_TEXTURE_ADDED: int = 1100
const NOTIFICATION_TEXTURE_CLEARED: int = 1101


signal texture_changed()


@export_custom(PROPERTY_HINT_ARRAY_TYPE, "", PROPERTY_USAGE_DEFAULT)
var _texture: Array[Texture2D]

@warning_ignore("unused_private_class_variable")
@export_tool_button("Add texture", "Texture2D")
var _add_texture_btn: Callable = _editor_add_texture

@warning_ignore("unused_private_class_variable")
@export_tool_button("Clear Textures", "Node")
var _clear_btn: Callable = _clear


var max_progress: float:
	get:
		return float(_texture.size()) - 1. if _texture.size() > 1 else 0.


var offset: float = 0.:
	get: return offset
	set(value):
		offset = value
		queue_redraw()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAW:
			var canvas_item_rid: RID = get_canvas_item()
			RenderingServer.canvas_item_clear(canvas_item_rid)
			
			if !_texture.is_empty():
				# draw 
				for i: int in range(_texture.size()):
					if i == 0:
						var background_texture: Texture2D = _texture[0]
						
						RenderingServer.canvas_item_add_texture_rect_region(
							canvas_item_rid, Rect2(Vector2(), get_size()),
							background_texture.get_rid(), Rect2(Vector2(), background_texture.get_size()),
							#modulate,
						)
					else:
						var _tex: Texture2D = _texture[i]
						var _texture_progress: float = clampf(offset - float(i - 1.), 0., 1.)
						var _sz: Vector2 = get_size()
						_sz.x *= _texture_progress
						
						var _texture_size: Vector2 = _tex.get_size()
						_texture_size.x *= _texture_progress
						
						RenderingServer.canvas_item_add_texture_rect_region(
							canvas_item_rid,
							Rect2(Vector2(), _sz),
							_tex.get_rid(),
							Rect2(Vector2(), _texture_size)
						)

		NOTIFICATION_TEXTURE_ADDED:
			if Engine.is_editor_hint():
				print("Texture Added")

		NOTIFICATION_TEXTURE_CLEARED:
			if Engine.is_editor_hint():
				print("Texture Cleared")


func _validate_property(property: Dictionary) -> void:
	if property.name == "offset":
		property.hint = PROPERTY_HINT_RANGE
		property.hint_string = "0.0, " + str(max_progress) + ", 0.01"
		property.usage = PROPERTY_USAGE_DEFAULT

#func _get_property_list() -> Array[Dictionary]:
	#var result: Array[Dictionary] = []
	#
	#result.push_back(
		#{
			#"name": 
		#}
	#)
	#
	#return


func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return

	if event is InputEventMouseMotion:
		var dragged: Vector2 = event.relative


func _clear() -> void:
	_texture.clear()
	notification(NOTIFICATION_TEXTURE_CLEARED)
	notify_property_list_changed()


func _editor_add_texture() -> void:
	var img: Array[Texture2D] = await ImageSelector.editor_get_image()
	
	if !img.is_empty():
		for tex: Texture2D in img:
			_texture.push_back(tex)
		
		notification(NOTIFICATION_TEXTURE_ADDED)
		notify_property_list_changed()
		queue_redraw()
