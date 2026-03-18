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
			

@export var gravity_direction: Vector2 = Vector2.DOWN
@export var area: float = 30000.:
	set(value):
		area = value
		#length_changed.emit(value)
		
@export var end_point: Vector2 = Vector2(300., 0.)

@export var tesselate_distance: float = 20.
@export var inout_max_ratio: float = 90.:
	get:
		return rad_to_deg(inout_max_ratio)
	set(value):
		inout_max_ratio = deg_to_rad(value)
		

@export var points: PackedVector2Array
@export_flags_2d_physics var mask: int = 1

@export var line_color: Color = Color(0.77, 0.0, 0.0, 1.0)

@export_category("DEBUG")
@export var draw_line_rect: bool = false
@export var draw_curve_point: bool = false

var _rect: Rect2 = Rect2()


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		_create_points()


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
	
	var bottom_middle_point: Vector2 = (left_bottom.distance_to(right_bottom) * .5) * left_bottom.direction_to(right_bottom)
	#var dir_start_to_middle_point: Vector2 = start_point.direction_to(middle_point)
	#var dir_end_to_middle_point: Vector2 = end_point.direction_to(middle_point)

	curve.add_point(start_point)
	curve.add_point(middle_point)
	curve.add_point(end_point)

	curve.set_point_out(0, start_point.distance_to(left_bottom) * gravity_direction)
	curve.set_point_in(1, end_point.direction_to(start_point) * bottom_middle_point.distance_to(left_bottom))
	curve.set_point_out(1, start_point.direction_to(end_point) * bottom_middle_point.distance_to(right_bottom))
	curve.set_point_in(2, end_point.distance_to(right_bottom) * gravity_direction)


func get_rect() -> Rect2:
	return Rect2()


func _physics_process(delta: float) -> void:
	pass


func _draw() -> void:
	if !points.is_empty():
		if draw_line_rect:
			draw_polyline(points, Color.WHITE)

	var curve_points: PackedVector2Array = []
	
	if curve.point_count > 0:
		var tesselated: PackedVector2Array = curve.tessellate_even_length(3, tesselate_distance)
		
		for i: int in range(curve.point_count):
			curve_points.push_back(curve.get_point_position(i))

		if draw_curve_point:
			draw_polyline(curve_points, Color.AQUA)

		draw_polyline(tesselated, line_color)


func _clear_points() -> void:
	curve.clear_points()
	points.clear()


func get_center_of_mass() -> Vector2:
	return Vector2()


func _exit_tree() -> void:
	if !Engine.is_editor_hint():
		_clear_points()
