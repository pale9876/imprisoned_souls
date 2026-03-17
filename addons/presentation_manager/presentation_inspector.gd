@tool
extends Control
class_name PresentationInspector



func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			pass
