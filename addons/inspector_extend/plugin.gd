@tool
extends EditorPlugin


var plugin: EditorInspectorPlugin


func _enter_tree() -> void:
	plugin = InspectorExtendPlugin.new()
	add_inspector_plugin(plugin)

func _exit_tree() -> void:
	if plugin:
		remove_inspector_plugin(plugin)
