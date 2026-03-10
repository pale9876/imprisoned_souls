@tool
extends EditorPlugin



var inspector_plugin: EditorInspectorPlugin

#func _enable_plugin() -> void:
	## Add autoloads here.
	#pass
#
#
#func _disable_plugin() -> void:
	## Remove autoloads here.
	#pass
#


func _enter_tree() -> void:
	inspector_plugin = MainInspectorPlugin.new()
	add_inspector_plugin(inspector_plugin)


func _exit_tree() -> void:
	remove_inspector_plugin(inspector_plugin)


class MainInspectorPlugin extends EditorInspectorPlugin:
	
	var editor_window: Window = null
	
	
	
	
	func _can_handle(object: Object) -> bool:
		return true
	
	func _parse_property(
			object: Object,
			type: Variant.Type,
			p_name: String,
			hint_type: PropertyHint,
			hint_string: String,
			usage_flags: int,
			wide: bool
		) -> bool:
		
		return false
	
	class ResourceProperty extends EditorProperty:
		pass
	
	
	
