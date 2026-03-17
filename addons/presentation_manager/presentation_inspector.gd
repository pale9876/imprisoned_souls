@tool
extends Control
class_name PresentationInspector




var edit: Control = null

@onready var add_scene_btn: Button = %AddScene


func _ready() -> void:
	add_scene_btn.button_up.connect(_add_scene)


func _add_scene() -> void:
	if edit_is_presentation():
		var scene: PresentationScene = PresentationScene.new()
		edit.add_child(scene)
		print("Add Scene")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			pass

		NOTIFICATION_FOCUS_EXIT:
			pass


func rename_presentation(value: String) -> bool:
	if edit:
		edit.title = value
		return true
		
	return false

func edit_is_presentation() -> bool:
	return edit and edit is Presentation
	
func edit_is_scene() -> bool:
	return edit and edit is PresentationScene
