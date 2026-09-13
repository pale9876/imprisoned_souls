# head_parts.gd
@tool
extends Node2D


enum Face {
	RIGHT = 1,
	LEFT = -1,
}


enum ZDir {
	FRONT = 1,
	BACK = -1,
}


@export var face: Face = Face.RIGHT:
	set(type):
		face = type
		direction = int(type)
		if is_node_ready():
			update_sprite_order()

@export var z_dir: ZDir = ZDir.FRONT:
	set(type):
		z_dir = type
		if is_node_ready():
			update_sprite_order()


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


func update_sprite_order() -> void:
	var order: Array[String] = get_head_sprite_order()
	
	for i: int in order.size():
		var attr := order[i] as String
		move_child(get_node(NodePath(attr)), i)


func get_head_sprite_order() -> Array[String]:
	const front_order: Array[String] = [
		"Ear", # Right Or Left
		"Tsuno", # Right Or Left
		"SideTail", # Right Or Left
		"Face",
		"FaceAccessory",
		"Ear", # Right Or Left
		"SideTail", # Right Or Left
		"Tsuno", # Right Or Left
		"FrontHair"
	]
	
	const back_order: Array[String] = [
		"FrontHair",
		"Ear", # Right Or Left
		"Tsuno", # Right Or Left
		"SideTail", # Right Or Left
		"FaceAccessory",
		"Face",
		"Ear", # Right Or Left
		"SideTail", # Right Or Left
		"Tsuno", # Right Or Left
	]
	
	var current_order: Array[String] = (front_order if z_dir == ZDir.FRONT else back_order).duplicate()
	var center_index: float = current_order.size() / 2.
	
	var left_or_right: Callable = func(i: int) -> String:
		if z_dir == ZDir.FRONT:
			if face == Face.RIGHT:
				return "Left" if i < center_index else "Right"
			else:
				return "Right" if i < center_index else "Left"
		else: # z_dir == ZDir.BACK
			if face == Face.RIGHT:
				return "Right" if i < center_index else "Left"
			else:
				return "Left" if i < center_index else "Right"
	
	for i: int in current_order.size():
		var attr: String = current_order[i]
		if attr in ["Tsuno", "SideTail", "Ear"]:
			current_order[i] += left_or_right.call(i) as String
	
	return current_order
