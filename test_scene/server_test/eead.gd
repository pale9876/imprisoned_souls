@tool
extends Node
class_name EEAD


# INFO
# Z축을 실수값으로 받는 2D 객체입니다.

@export_category("Warning")
@export var do_not_test_in_editor: bool = false

@export_category("2.5")
@export var pin: bool = false
@export var z_value: float:
	set(value):
		if !pin:
			if get_parent() and get_parent() is Endeka:
				var parent: Endeka = get_parent() as Endeka
				z_value = clampf(value, parent.min_z, parent.max_z)
				parent.notification(Endeka.NOTIFICATION_EEAD_Z_VALUE_CHANGED)
			else:
				z_value = value
@export var position: Vector2 = Vector2()
@export var visible: bool = true:
	set(toggle):
		visible = toggle
		RenderingServer.canvas_item_set_visible(canvas_item, toggle)

@export_tool_button("Create", "2D") var _create: Callable = create


var init: bool = false
var canvas_item: RID


func get_canvas_item() -> RID:
	return canvas_item


func get_canvas() -> RID:
	return get_parent().get_canvas()


func _init() -> void:
	canvas_item = RenderingServer.canvas_item_create()


func free() -> void:
	RenderingServer.free_rid(canvas_item)



func _notification(what: int) -> void:
	if what == NOTIFICATION_ENTER_TREE:
		if get_parent() is Endeka:
			RenderingServer.canvas_item_set_parent(
				get_canvas_item(), get_canvas()
			)
	elif what == NOTIFICATION_EXIT_TREE:
		RenderingServer.canvas_item_set_parent(get_canvas_item(), RID())


# OVERRIDE
func create() -> void:
	pass


# OVERRIDE
func kill() -> void:
	pass
