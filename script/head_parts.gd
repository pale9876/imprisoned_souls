# head_parts.gd
@tool
extends Node2D


enum Face {
	LEFT = -1,
	RIGHT = 1
}


enum ZDir {
	FRONT = -1,
	BACK = 1,
}


@export var face: Face = Face.RIGHT
@export var z_dir: ZDir = ZDir.FRONT


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
	
	var current_order: Array[String] = front_order if z_dir == ZDir.FRONT else back_order
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
