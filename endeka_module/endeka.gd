@tool
extends CanvasLayer

class_name Endeka

# INFO
# 하위 EEAD의 Z값 변화에 따라 EndekaRenderItem을 내림차순으로 정렬합니다.
const NOTIFICATION_EEAD_Z_VALUE_CHANGED: int = 1402
const NOTIFICATION_MINMAX_CHANGED: int = 1403
const NOTIFICATION_CREATED: int = 1440
const NOTIFICATION_KILLED: int = 1441

@export_category("Z Layer Range")
@export var min_z: float = 0.:
	set(value):
		if max_z > min_z:
			min_z = value
		else:
			min_z = value
		notification(NOTIFICATION_MINMAX_CHANGED)
@export var max_z: float = 100.:
	set(value):
		if min_z <= value:
			max_z = value
		notification(NOTIFICATION_MINMAX_CHANGED)

@export_category("Option")
@export var ysorting: bool = false
@export var auto_init: bool = false

@warning_ignore("unused_private_class_variable")
@export_tool_button("Sort", "2D") var _sort: Callable = sort
@warning_ignore("unused_private_class_variable")
@export_tool_button("Draw EEADs", "2D") var _draw_eeads: Callable = draw_eeads
@warning_ignore("unused_private_class_variable")
@export_tool_button("Create", "2D") var _create: Callable = create

var reserve: bool = false
var init: bool = false


# OVERRIDE
func create() -> void:
	notification(NOTIFICATION_CREATED)


# OVERRIDE
func kill() -> void:
	notification(NOTIFICATION_KILLED)


func _notification(what: int) -> void:
	if what == NOTIFICATION_EEAD_Z_VALUE_CHANGED:
		reserve = true

	elif what == NOTIFICATION_MINMAX_CHANGED:
		for eead in get_eead():
			(eead as EEAD).z_value = clampf((eead as EEAD).z_value, min_z, max_z)

	elif what == NOTIFICATION_ENTER_TREE:
		if auto_init:
			create()

	elif what == NOTIFICATION_READY:
		sort()

	elif what == NOTIFICATION_CREATED:
		init = true

	elif what == NOTIFICATION_KILLED:
		pass


func _process(_delta: float) -> void:
	if reserve:
		sort()
		reserve = false


func sort() -> Array:
	var arr: Array = get_eead()

	if ysorting:
		arr.sort_custom(
			func(a: EEAD, b: EEAD) -> bool:
				return a.z_value < b.z_value
		)

		arr.sort_custom(
			func(a: EEAD, b: EEAD) -> bool:
				return (a.z_value == b.z_value) and a.position.y < b.position.y
		)
	else:
		arr.sort_custom(
			func(a: EEAD, b: EEAD) -> bool:
				return a.z_value < b.z_value
		)

	for i: int in arr.size():
		var eead: = arr[i] as EEAD
		if eead.init:
			RenderingServer.canvas_item_set_draw_index(eead.get_canvas_item(), i)

	return arr


func draw_eeads() -> void:
	var arr: Array = sort()

	if init:
		for eead in arr:
			eead.kill()

	for eead in arr:
		eead.create()

	init = true


func get_eead() -> Array:
	return get_children().filter(func(node: Node) -> bool: return node is EEAD)


func get_global_mouse_position() -> Vector2:
	return get_viewport().canvas_transform.affine_inverse().basis_xform(
		get_viewport().get_mouse_position(),
	)
