# 항상 Upper / Lower / Weapon으로 나누어집니다.
@tool
extends Node2D
class_name SpritePartsGroup


enum Face {
	RIGHT = 1,
	LEFT = -1,
}


@export var parts_order: Dictionary[String, Array] = {
	"Default" : [
		"Upper", "Lower", "Weapon"
	]
}

@export var order: String = "Default":
	set(value):
		order = value
		if is_node_ready():
			if order in parts_order.keys():
				var current_order: Array = parts_order[order]
				for i: int in current_order.size():
					var target_node: Node = get_node(NodePath(current_order[i] as String))
					move_child(target_node, i)


@export var hframes: int = 1:
	set(val):
		hframes = maxi(1, val)
		propagate_hframes()

@export var vframes: int = 1:
	set(val):
		vframes = maxi(1, val)
		propagate_vframes()

@export_custom(
	PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_KEYING_INCREMENTS
) var frame: int = 0:
	set(val):
		frame = clampi(val, 0, hframes * vframes - 1)
		propagate_frame()

@export_range(-1, 1, 2) var direction: int = 1:
	set(val):
		direction = clampi(val, -1, 1)
		propagate_direction()


func propagate_frame() -> void:
	for node: Node in get_children():
		if node is DirectionSpriteModuler:
			node.frame = frame

func propagate_direction() -> void:
	for node: Node in get_children():
		if node is DirectionSpriteModuler:
			node.direction = direction


func propagate_vframes() -> void:
	for node: Node in get_children():
		if node is DirectionSpriteModuler:
			node.vframes = vframes


func propagate_hframes() -> void:
	for node: Node in get_children():
		if node is DirectionSpriteModuler:
			node.hframes = hframes


func propagate_info() -> void:
	for node: Node in get_children():
		if node is DirectionSpriteModuler:
			node.vframes = vframes
			node.hframes = hframes
			node.frame = frame
