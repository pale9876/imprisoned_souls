@tool
extends Node2D
class_name SilkPhysicsCurveLine2D


enum State{
	CCD,
	JOINT,
	CAST,
}



signal length_changed(value: float)


@export var test_mode: bool = false
@export var state: State = State.CAST

@export var curve2d: Curve2D

@export var start_point: Vector2 = Vector2.ZERO:
	set(value):
		if end_point.distance_squared_to(value) < length ** 2:
			start_point = value
			_create_points()
		queue_redraw()

@export var end_point: Vector2 = Vector2(300., 0.):
	set(value):
		if start_point.distance_squared_to(value) < length ** 2:
			end_point = value
			_create_points()
		
		queue_redraw()

@export var length: float = 300.:
	set(value):
		length = value
		_create_points()
		queue_redraw()

@export_range(1, 5, 2) var step: int = 3


@export var points: PackedVector2Array
@export var points_rid: Array[RID]
@export_flags_2d_physics var mask: int = 1


func dist_point_by_point() -> float:
	return length / float(step + 1)


func _양_끝점의_길이() -> float:
	return sqrt(start_point.distance_squared_to(end_point))


func _create_points() -> void:
	points.clear()
	
	points.push_back(start_point)
	
	var pnt_dist_step: Vector2 = (start_point.direction_to(end_point) * _양_끝점의_길이()) / (float(step) + 1.)
	
	for i: int in range(1, 5, 1):
		var point: Vector2 = start_point + (pnt_dist_step * float(i))
		points.push_back(point)
	
	points.push_back(end_point)
	
	if state != State.CAST:
		# TODO: PhysicsServer2D에서 body, shape 생성
		pass


func _get_default_gravity(_delta: float) -> Vector2:
	return Vector2(0., 970. * _delta)


func _enter_tree() -> void:
	_create_points()


func _physics_process(delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	
	if !Engine.is_editor_hint() or (test_mode and Engine.is_editor_hint()):
		if state == State.CAST:
			for i: int in range(1, points.size(), 1):
				var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
					global_position + points[i],
					global_position + points[i] + _get_default_gravity(delta),
					mask,
				)
				query.hit_from_inside = true
				var result: Dictionary = space_state.intersect_ray(
					query
				)
				
				if !result.is_empty():
					var collide_point: Vector2 = result.position
					var normal: Vector2 = result.normal
			
	
	queue_redraw()


func _draw() -> void:
	for point: Vector2 in points:
		draw_circle(
			point, 3., Color.WHITE
		)

#region !! deprecated !! joint 모드를 위해 일시적으로 주석처리하였습니다.
	#var space: RID = get_world_2d().space
	#
	#for i: int in range(step + 2):
		#var p_body_rid: RID = PhysicsServer2D.body_create()
		#var p_shape_rid: RID = PhysicsServer2D.circle_shape_create()
		#var circle_radius: float = 1.
		#
		#PhysicsServer2D.shape_set_data(
			#p_shape_rid, circle_radius
		#)
		#
		#PhysicsServer2D.body_add_shape(
			#p_body_rid,
			#p_shape_rid,
			#Transform2D(
				#0., Vector2.ONE, 0.,
				#Vector2(length * (float(i) / float(step + 2 - 1)), 0.) # position
			#)
		#)
		#
		#PhysicsServer2D.body_set_mode(p_body_rid, PhysicsServer2D.BODY_MODE_KINEMATIC)
		#
		#PhysicsServer2D.body_set_space(p_body_rid, space)
#endregion


func _exit_tree() -> void:
	_clear_points()


func _clear_points() -> void:
	points.clear()
	
	for rid: RID in points_rid:
		PhysicsServer2D.free_rid(rid)
