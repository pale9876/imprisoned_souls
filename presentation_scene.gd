@tool
extends Control
class_name PresentationScene


@export var title: String = "SceneTitle":
	set(value):
		title = value


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PATH_RENAMED:
			pass
