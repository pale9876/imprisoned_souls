@tool
extends EditorPlugin


const PRESENTATION_INSPECTOR_SCENE: PackedScene = preload("uid://vj3mtpe7yn1q")

const NOTIFICATION_PRESENTATION_SELECTED: int = 1200
const NOTIFICATION_SCENE_SELECTED: int = 1201
const NOTIFICATION_EDIT_OBJECT_CHANGED: int = 1202


var presentation_dock: EditorDock
var presentation_inspector: PresentationInspector = null


func _enter_tree() -> void:
	if !presentation_inspector:
		# ADD DOCK
		presentation_dock = EditorDock.new()
		presentation_dock.title = "Presentation"
		presentation_dock.default_slot = EditorDock.DOCK_SLOT_LEFT_BR
		add_dock(presentation_dock)

		# ADD INSPECTOR
		presentation_inspector = PRESENTATION_INSPECTOR_SCENE.instantiate()
		presentation_inspector.undoredo = get_undo_redo()
		presentation_dock.add_child(presentation_inspector)


		# CONNECT TO INSPECTOR
		EditorInterface.get_inspector().edited_object_changed.connect(_on_edit_object_changed)


func _on_edit_object_changed() -> void:
	var inspector: EditorInspector = EditorInterface.get_inspector()
	var _edit: Object = inspector.get_edited_object()

	if _edit is Presentation:
		notification(NOTIFICATION_PRESENTATION_SELECTED)

	elif _edit is PresentationScene:
		notification(NOTIFICATION_SCENE_SELECTED)
	
	else:
		notification(NOTIFICATION_EDIT_OBJECT_CHANGED)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			pass

		NOTIFICATION_PRESENTATION_SELECTED:
			var inspector: EditorInspector = EditorInterface.get_inspector()
			var _edit: Object = inspector.get_edited_object()
			
			presentation_inspector.edit = _edit

		NOTIFICATION_SCENE_SELECTED:
			var inspector: EditorInspector = EditorInterface.get_inspector()
			var _edit: Object = inspector.get_edited_object()
			
			presentation_inspector.edit = _edit

		NOTIFICATION_EDIT_OBJECT_CHANGED:
			presentation_inspector.tab_container.hide()



func _exit_tree() -> void:
	if presentation_inspector:
		remove_dock(presentation_dock)
		presentation_inspector.queue_free()

		EditorInterface.get_inspector().edited_object_changed.disconnect(_on_edit_object_changed)
