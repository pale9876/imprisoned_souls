@tool
extends EditorPlugin


var collide_info_editor_plugin: CollideInfoEditorPlugin = null


func _enter_tree() -> void:
	collide_info_editor_plugin = CollideInfoEditorPlugin.new()
	add_inspector_plugin(collide_info_editor_plugin)

func _exit_tree() -> void:
	if collide_info_editor_plugin:
		remove_inspector_plugin(collide_info_editor_plugin)
