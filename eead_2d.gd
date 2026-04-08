@tool
extends Node2D
class_name EEAD2D


# INFO
# Z축을 실수값으로 받는 2D 객체입니다.

@export_category("Warning")
@export var do_not_test_in_editor: bool = false

@export_category("2.5")
@export var pin: bool = false
@export var z_value: float:
	set(value):
		if !pin:
			if get_parent() and get_parent() is EndekaSorter:
				var parent: EndekaSorter = get_parent() as EndekaSorter
				z_value = clampf(value, parent.min_z, parent.max_z)
				parent.notification(EndekaSorter.NOTIFICATION_EEAD_Z_VALUE_CHANGED)
			else:
				z_value = value


@export_tool_button("Create", "2D") var _create: Callable = create


var init: bool = false


func _notification(what: int) -> void:
	if what == NOTIFICATION_ENTER_TREE:
		if get_parent() is EndekaSorter:
			(get_parent() as EndekaSorter).sort()


# OVERRIDE
func create() -> void:
	pass


# OVERRIDE
func kill() -> void:
	pass
