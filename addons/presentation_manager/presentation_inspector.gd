@tool
extends Control
class_name PresentationInspector


const NOTIFICATION_EDIT_OBJECT_CHANGED: int = 1400


var edit: Control = null:
	set(obj):
		edit = obj
		notification(NOTIFICATION_EDIT_OBJECT_CHANGED)


var undoredo: EditorUndoRedoManager

@onready var tab_container: TabContainer = %TabContainer

@onready var add_scene_btn: Button = %AddScene
@onready var clear_all_scenes_btn: Button = %ClearAllScenes


func _ready() -> void:
	add_scene_btn.button_up.connect(_add_scene)
	clear_all_scenes_btn.button_up.connect(_clear_all_scenes)


func _clear_all_scenes() -> void:
	if edit is Presentation:
		
		edit.clear_scenes()


func _add_scene() -> void:
	if edit is Presentation:
		var scene: PresentationScene = PresentationScene.new()
		edit.add_child(scene)
		scene.set_owner(edit)
		print("Add Scene")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			pass


		NOTIFICATION_FOCUS_EXIT:
			pass


		NOTIFICATION_FOCUS_ENTER:
			pass


		NOTIFICATION_EDIT_OBJECT_CHANGED:
			if edit_is_presentation():
				tab_container.current_tab = tab_container.get_node("%Pressentation").get_index()
			elif edit_is_scene():
				tab_container.current_tab = tab_container.get_node("%Scene").get_index()


func rename_presentation(value: String) -> bool:
	if edit:
		edit.title = value
		return true
		
	return false


func edit_is_presentation() -> bool:
	return edit != null and edit is Presentation
	
func edit_is_scene() -> bool:
	return edit != null and edit is PresentationScene
