@tool
extends Node2D
class_name SilkCurveLine2D


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
@export var inout_max_ratio: float = PI / 2.:
	get:
		return rad_to_deg(inout_max_ratio)
	set(value):
		inout_max_ratio = deg_to_rad(value)
		

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
	
	
	var middle_point: Vector2 = Vector2((end_point.x - start_point.x) / 2., right_bottom.y)
	var dir_start_to_middle_point: Vector2 = start_point.direction_to(middle_point)
	var dir_end_to_middle_point: Vector2 = end_point.direction_to(middle_point)

	curve.add_point(start_point)
	curve.add_point(middle_point)
	curve.add_point(end_point)


func _draw() -> void:
	var curve_points: PackedVector2Array = []
	
	if curve.point_count > 0:
		for i: int in range(curve.point_count):
			curve_points.push_back(curve.get_point_position(i))
	
	draw_polyline(curve_points, Color.AQUA)
	
	
	if !points.is_empty():
		draw_polyline(points, Color.WHITE)


func _clear_points() -> void:
	curve.clear_points()
	points.clear()


func get_center_of_mass() -> Vector2:
	return Vector2()


func _exit_tree() -> void:
	if !Engine.is_editor_hint():
		_clear_points()
