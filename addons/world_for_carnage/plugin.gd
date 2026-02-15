@tool
extends EditorPlugin

const icon_image: Texture2D = preload("uid://c3pc3e1amg4sh")
const world_creator_ui_scene: PackedScene = preload("uid://byey5o4y5fpgt")
var _world_creator: Control = null


func _enable_plugin() -> void:
	print("Welcome to World Creator Master.")


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	_world_creator = world_creator_ui_scene.instantiate()
	EditorInterface.get_editor_main_screen().add_child(_world_creator)
	_make_visible(false)


func _make_visible(visible: bool) -> void:
	if _world_creator:
		if visible:
			_world_creator.show()
		else:
			_world_creator.hide()


func _has_main_screen() -> bool: return true


func _exit_tree() -> void:
	if _world_creator:
		_world_creator.queue_free()


func _get_plugin_icon() -> Texture2D: return icon_image


func _get_plugin_name() -> String: return "WorldCreator"
