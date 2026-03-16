@tool
extends Node2D
class_name SilkPhysicsCurveLine2D


@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY)
var curve: Curve2D = Curve2D.new()

@export var test_mode: bool = false:
	set(toggle):
		test_mode = toggle
		if Engine.is_editor_hint():
			if toggle:
				_create_points()
				queue_redraw()
			else:
				_clear_points()
				queue_redraw()
			

@export var gravity_scale: float = 1.0
@export var area: float = 30000.:
	set(value):
		area = value
		#length_changed.emit(value)
@export var end_point: Vector2 = Vector2(300., 0.)
@export_range(3, 64, 1) var step: int = 64
@export var inout_max_ratio: float = PI / 2.

@export var points: PackedVector2Array
@export_flags_2d_physics var mask: int = 1


func _enter_tree() -> void:
	if !Engine.is_editor_hint(): _create_points()


func _create_points() -> void:
	var silk_direction: Vector2 = end_point.normalized()
	var dist_to_end: float = end_point.length()
	var height: float = area / dist_to_end
	
	var start_point: Vector2 = Vector2()
	var left_bottom: Vector2 = Vector2(0., height).rotated(silk_direction.angle())
	var right_bottom: Vector2 = Vector2(end_point.length(), height).rotated(silk_direction.angle())
	
	points.push_back(start_point)
	points.push_back(left_bottom)
	points.push_back(right_bottom)
	points.push_back(end_point)
	
	var middle_point: Vector2 = Vector2(end_point.x - start_point.x, right_bottom.y)
	var dir_start_to_middle_point: Vector2 = start_point.direction_to(middle_point)
	var dir_end_to_middle_point: Vector2


	for point: Vector2 in points:
		curve.add_point(point)
	
	#curve.set_point_out()


 


func _draw() -> void:
	if !points.is_empty():
		draw_polyline(points, Color.WHITE)


func _clear_points() -> void:
	points.clear()


func get_center_of_mass() -> Vector2:
	return Vector2()


func _exit_tree() -> void:
	if !Engine.is_editor_hint():
		_clear_points()
