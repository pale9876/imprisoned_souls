# keikai.gd
@tool
extends StaticBody2D
class_name KeiKai


@export var _left: int:
	set(value):
		_left = mini(_right, value)
		if Engine.is_editor_hint() and is_node_ready():
			set_keikai(get_values())
@export var _right: int:
	set(value):
		_right = maxi(_left, value)
		if Engine.is_editor_hint() and is_node_ready():
			set_keikai(get_values())
@export var _ceil: int:
	set(value):
		_ceil = mini(value, _floor)
		if Engine.is_editor_hint() and is_node_ready():
			set_keikai(get_values())
@export var _floor: int:
	set(value):
		_floor = maxi(value, _ceil)
		if Engine.is_editor_hint() and is_node_ready():
			set_keikai(get_values())

# Editor
@export var color: Color = Color(0.529, 1.0, 0.901, 0.118)


func _init() -> void:
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)

	input_pickable = false


func _enter_tree() -> void:
	global_position = Vector2()


func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(
			get_region(),
			color, true
		)

func get_region() -> Rect2:
	var val: Vector4 = get_values()
	var width: float = val.y - val.x
	var height: float = val.w - val.z
	
	return Rect2(Vector2(val.x, val.z), Vector2(width, height))


func set_values(value: Vector4i) -> void:
	_left = value.x
	_right = value.y
	_ceil = value.z
	_floor = value.w
	
	if !Engine.is_editor_hint():
		set_keikai(Vector4(value))


func set_keikai(value: Vector4) -> void:
	get_left().global_position = Vector2(value.x, 0.)
	get_right().global_position = Vector2(value.y, 0.)
	get_ceil().global_position = Vector2(0., value.z)
	get_floor().global_position = Vector2(0., value.w)
	
	if Engine.is_editor_hint():
		queue_redraw()


func get_values() -> Vector4:
	return Vector4(
		float(_left), float(_right), float(_ceil), float(_floor)
	)


func get_ceil() -> CollisionShape2D:
	return get_node(^"Ceil") as CollisionShape2D


func get_left() -> CollisionShape2D:
	return get_node(^"Left") as CollisionShape2D


func get_right() -> CollisionShape2D:
	return get_node(^"Right") as CollisionShape2D


func get_floor() -> CollisionShape2D:
	return get_node(^"Floor") as CollisionShape2D
