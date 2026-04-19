@tool
extends CanvasLayer
class_name Endeka


# INFO
# 하위 EEAD의 Z값 변화에 따라 EndekaRenderItem을 내림차순으로 정렬합니다.


const NOTIFICATION_EEAD_Z_VALUE_CHANGED: int = 1402
const NOTIFICATION_MINMAX_CHANGED: int = 1403


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

@export_category("Sort Option")
@export var ysorting: bool = true


@export_tool_button("Sort", "2D") var _sort: Callable = sort
@export_tool_button("Draw EEADs", "2D") var _draw_eeads: Callable = draw_eeads


var reserve: bool = false


func _notification(what: int) -> void:
	if what == NOTIFICATION_EEAD_Z_VALUE_CHANGED:
		reserve = true

	elif what == NOTIFICATION_MINMAX_CHANGED:
		for eead in get_eead():
			(eead as EEAD).z_value = clampf((eead as EEAD).z_value, min_z, max_z)

	elif what == NOTIFICATION_READY:
		sort()


func _process(delta: float) -> void:
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
			func(a:EEAD, b: EEAD) -> bool:
				return (a.z_value == b.z_value) and a.position.y < b.position.y
		)
	else:
		arr.sort_custom(
			func(a: EEAD, b: EEAD) -> bool:
				return a.z_value < b.z_value
		)

	var idx: int = 0

	for eead in arr:
		RenderingServer.canvas_item_set_draw_index(
			eead.get_canvas_item(), idx
		)
		idx += 1

	return arr


func draw_eeads() -> void:
	var arr: Array = sort()
	
	for eead in arr:
		if eead is EEAD: eead.create()


func get_eead() -> Array:
	return get_children().filter(func(node: Node) -> bool: return node is EEAD)
