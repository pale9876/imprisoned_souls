@tool
extends EEAD2D
class_name EndekaSorter


# INFO
# 하위 EEAD의 Z값 변화에 따라 EndekaRenderItem을 내림차순으로 정렬합니다.


const NOTIFICATION_EEAD_Z_VALUE_CHANGED: int = 1402
const NOTIFICATION_MINMAX_CHANGED: int = 1403


@export var min_z: float = 0.:
	set(value):
		if max_z > min_z:
			max_z = value
			min_z = value
		else:
			min_z = value
		notification(NOTIFICATION_MINMAX_CHANGED)
@export var max_z: float = 100.:
	set(value):
		if min_z <= value:
			max_z = value
		notification(NOTIFICATION_MINMAX_CHANGED)


@export_tool_button("Sort", "2D") var _sort: Callable = sort


var reserve: bool = false


func _notification(what: int) -> void:
	if what == NOTIFICATION_EEAD_Z_VALUE_CHANGED:
		reserve = true
		
	elif what == NOTIFICATION_MINMAX_CHANGED:
		for eead in get_eead():
			(eead as EEAD2D).z_value = clampf((eead as EEAD2D).z_value, min_z, max_z)


func _process(delta: float) -> void:
	if reserve:
		sort()
		reserve = false


func sort() -> void:
	var arr: Array = get_eead()
	
	arr.sort_custom(
		func(a: EEAD2D, b: EEAD2D) -> bool: return a.z_value < b.z_value
	)
	
	var idx: int = 0
	var prev_val: float = arr[0].z_value
	for eead in arr:
		(eead as EEAD2D).z_index = idx
		if prev_val != eead.z_value:
			prev_val = idx
			idx += 1


func get_eead() -> Array:
	return get_children().filter(
			func(node: Node) -> bool: return node is EEAD2D
		).map(
			func(node: Node) -> EEAD2D: return node as EEAD2D
		)
