@tool
extends Control
class_name PresentationScene


@export var root: Presentation


@export var title: String = "SceneTitle":
	set(value):
		title = value
		


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			pass
		
		NOTIFICATION_PATH_RENAMED:
			pass
