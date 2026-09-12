# karada_moduler.gd
@tool
extends Node2D
class_name KaradaModule


const HeadParts: Script = preload("uid://v08g5hwim8i0")


const ORDER_BY_PARTS: Dictionary[String, Array] = {
	"Default" : [
			"BackHairAccessory",
			"BackHair",
			"BodyBackRace",
			"ArmRight",
			"LegLeft",
			"Body",
			"LegRight",
			"ArmLeft",
			"Head",
			"FrontHairAccessory"
	],
}


@export var order: String = "Default":
	set(type):
		order = type
		if ORDER_BY_PARTS.has(order):
			ordering_parts(order)

@export var parts_groups: Array[Node2D] = []


@export_range(-1, 1, 2) var direction: int = 1:
	set(val):
		if direction != val and is_node_ready() and direction != 0:
			direction = val
			for node: Node in get_children():
				if node is not Node2D: return
				
				if node.name in [&"Head", &"ArmRight", &"ArmLeft", &"LegRight", &"LegLeft"]:
					for head_part: Node in node.get_children():
						(head_part as DirectionSpriteModuler).direction = direction
					update_face_dir()
				elif node is DirectionSpriteModuler:
					node.direction = direction
				
			ordering_parts(order)

@export_enum("NONE", "Left", "Right", "BOTH") var weapon_handle: String = "NONE"


func _ready() -> void:
	order = "Default"


func order_place_arm_by_dir(_order: String) -> PackedStringArray:
	var result: PackedStringArray = PackedStringArray()
	
	if !ORDER_BY_PARTS.has(_order):
		return []
	
	var values: PackedStringArray = ORDER_BY_PARTS[_order]
	
	result.resize(values.size())
	
	for index: int in range(result.size()):
		var _str: String = values[index]
		if direction == -1:
			if _str == "RightArm":
				result[index] = "LeftArm"
			elif _str == "LeftArm":
				result[index] = "RightArm"
			else:
				result[index] = _str
		else:
			result[index] = _str

	return result


func update_face_dir() -> void:
	pass


func ordering_parts(_order: String) -> void:
	if !is_node_ready(): return
	
	var parts_order: PackedStringArray = order_place_arm_by_dir(order)
	
	if parts_order.is_empty(): return
	
	for index: int in range(get_child_count()):
		var node_name: StringName = get_child(index).name
		var cursor: String = parts_order[index]
		if node_name != StringName(cursor):
			move_child(get_node(NodePath(cursor)), index)


func get_head() -> HeadParts:
	return get_node(^"Head") as HeadParts
