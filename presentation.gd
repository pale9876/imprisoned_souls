@tool
extends Control
class_name Presentation


const NOTIFICATION_PRESENTATION_RENAMED: int = 1100


@export var title: String = "NewPresentation":
	set(value):
		title = value
		notification(NOTIFICATION_PRESENTATION_RENAMED)


@export var scenes: Dictionary[int, String] = {}

@export var title_scene: PresentationScene


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_CHILD_ORDER_CHANGED:
			clear_scenes()
			list_scenes()
			
		NOTIFICATION_ENTER_TREE:
			clear_scenes()
			list_scenes()

		NOTIFICATION_PRESENTATION_RENAMED:
			if title.is_empty(): return
			
			var fix: String = title.replace(" ", "_")
			for node: Node in get_children():
				if node.name == title:
					pass
			name = StringName(fix)


func clear_scenes() -> void:
	scenes = {}


func list_scenes() -> Dictionary[int, String]:
	var result: Dictionary[int, String] = {}
	
	for node in get_children():
		if node is PresentationScene:
			result[node.get_index()] = node.name

	scenes = result
	
	return result


class SavePres extends Resource:
	var title: String = ""
