@tool
extends EditorPlugin


const PRESENTATION_INSPECTOR_SCENE: PackedScene = preload("uid://vj3mtpe7yn1q")


var presentation_dock: EditorDock
var presentation_inspector: PresentationInspector = null


func _enter_tree() -> void:
	if !presentation_inspector:
		presentation_dock = EditorDock.new()
		presentation_inspector = PRESENTATION_INSPECTOR_SCENE.instantiate()
		add_dock(presentation_dock)




func _on_edit_object_changed() -> void:
	pass


func _notification(what: int) -> void:
	pass


func _exit_tree() -> void:
	if presentation_inspector:
		remove_dock(presentation_dock)
		presentation_inspector.queue_free()
		
