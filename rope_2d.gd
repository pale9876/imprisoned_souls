@tool
extends Node2D


@export var start_point: Vector2 = Vector2.ZERO:
	set(value):
		start_point = value
		queue_redraw()
@export var end_point: Vector2 = Vector2(100., 0.):
	set(value):
		end_point = value
		queue_redraw()

@export var length: float = 300.:
	set(value):
		length = value
		queue_redraw()

@export var points: PackedVector2Array


func _draw() -> void:
	create_points()
	print(get_absolute_height())
	print(rad_to_deg(_break_point_rad()))

	draw_polyline(points, Color.ALICE_BLUE)


func _break_point_rad() -> float:
	var dist: float = start_point.distance_to(end_point)
	var height: float = get_absolute_height()
	var hypotenuse: float = sqrt(((dist / 2.) ** 2) + (height ** 2))
	return cos((dist / 2.) / hypotenuse) * 2.


func get_absolute_height() -> float:
	var dist: float = get_dist() / 2.
	var area: float = length / 2.
	return sqrt((area ** 2) - (dist ** 2))


func get_dist() -> float:
	return start_point.distance_to(end_point)


func create_points() -> void:
	points = []
	points.push_back(start_point)
	points.push_back(Vector2(get_dist() / 2., get_absolute_height()))
	points.push_back(end_point)
