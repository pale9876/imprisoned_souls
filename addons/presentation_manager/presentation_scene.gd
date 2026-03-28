@tool
extends Control
class_name PresentationScene


const NOTIFICATION_ENTER_PRESENTATION: int = 1300



var _template: Resource:
	set(res):
		_template = res


@export var root: Presentation


@export var sub_title: String = ""


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			var parent: Node = get_parent()
			if parent is Presentation:
				root = parent
				notification(NOTIFICATION_ENTER_PRESENTATION)

		NOTIFICATION_PATH_RENAMED:
			sub_title = name

		NOTIFICATION_ENTER_PRESENTATION:
			pass


class SceneTemplate extends Resource:
	pass


class TitleScene extends SceneTemplate:
	pass
