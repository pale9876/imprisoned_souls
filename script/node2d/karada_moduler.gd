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
	set(value):
		order = value
		if ORDER_BY_PARTS.has(value):
			ordering_parts(value)


@export_range(-1, 1, 2) var direction: int = 1:
	set(val):
		if is_node_ready():
			if direction != val and direction != 0:
				direction = val
				for node: Node in get_children():
					if node is not Node2D: return

					if node.name == &"Head":
						update_head_dir()
					elif node is DirectionSpriteModuler:
						node.direction = direction
					elif node is SpritePartsGroup:
						pass
				ordering_parts(order)


@export_custom(
	PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_KEYING_INCREMENTS
) var frame: int = 0:
	set(val):
		frame = maxi(val, 0)
		propagate_frame()


func _ready() -> void:
	order = "Default"


func propagate_frame() -> void:
	for node: Node in get_children():
		if node is DirectionSpriteModuler:
			node.frame = frame


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


func update_head_dir() -> void:
	get_head()


func ordering_parts(_order: String) -> void:
	if !is_node_ready(): return
	
	var parts_order: PackedStringArray = order_place_arm_by_dir(_order)
	
	if parts_order.is_empty(): return
	
	for index: int in range(get_child_count()):
		var node_name: StringName = get_child(index).name
		var cursor: String = parts_order[index]
		if node_name != StringName(cursor):
			move_child(get_node(NodePath(cursor)), index)


func get_head() -> HeadParts:
	return get_node(^"Head") as HeadParts




	
