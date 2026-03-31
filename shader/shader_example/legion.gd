@tool
extends Node2D
class_name Legion


@export var instance: Array[LegionInstance]
@export var init_rect_size: Vector2i = Vector2i(128, 128)
@export var image_save_path: String = ""

@export var placeholder: Texture


@export_tool_button("Create Instance", "Object") var _create: Callable = create_instance
@export_tool_button("Remove Instance", "Object") var _remove: Callable = _remove_last_instance


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if image_save_path.is_empty():
				create_color_rect()
			else:
				placeholder = load(image_save_path)
			
			for res: LegionInstance in instance:
				res.init_instance(get_canvas_item())
		
		NOTIFICATION_DRAW:
			if !instance.is_empty():
				for res: LegionInstance in instance:
					res.update()

		NOTIFICATION_EXIT_TREE:
			for res: LegionInstance in instance:
				res.remove_instance()


func create_color_rect() -> void:
	if Engine.is_editor_hint():
		var default_save_path: String = "res://shader/shader_example/imgs/color_rect_image.png"
		var color_image: Image = Image.create_empty(
			init_rect_size.x, init_rect_size.y, false, Image.FORMAT_RGBA8
		)
		
		color_image.fill_rect(
			Rect2i(Vector2i(), init_rect_size), Color.WHITE
		)
		
		var t: ImageTexture = ImageTexture.create_from_image(color_image)
		
		var err: Error = color_image.save_png(default_save_path)
		
		if err != OK:
			printerr(err, " => Image Save Failed")
			return

		image_save_path = default_save_path
		placeholder = t


func create_instance() -> void:
	var rect_instance: LegionInstance = LegionInstance.create_instance( get_canvas_item() )
	rect_instance.texture = placeholder
	
	instance.push_back(rect_instance)
	rect_instance.update()

	notify_property_list_changed()


func _remove_last_instance() -> void:
	if !instance.is_empty():
		remove(instance[instance.size() - 1])
	
	notify_property_list_changed()


func remove(res: LegionInstance) -> bool:
	if instance.has(res):
		instance.erase(res)
		res.remove_instance()
		notify_property_list_changed()
		return true
	
	return false
