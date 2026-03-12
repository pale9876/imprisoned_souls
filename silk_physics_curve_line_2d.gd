@tool
extends Node2D
class_name SilkPhysicsCurveLine2D


signal length_changed(value: float)


@export var test_mode: bool = false

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

@export_tool_button("Restore", "Node") var _restore: Callable = func() -> void: _create_points(); queue_redraw();

func dist_point_by_point() -> float:
	return length / float(step + 1)


func _양_끝점의_길이() -> float:
	return sqrt(start_point.distance_squared_to(end_point))


func _create_points() -> void:
	_clear_points()
	
	points.push_back(start_point)
	
	var pnt_dist_step: Vector2 = (start_point.direction_to(end_point) * _양_끝점의_길이()) / (float(step) + 1.)
	
	for i: int in range(1, step + 1, 1):
		var point: Vector2 = start_point + (pnt_dist_step * float(i))
		points.push_back(point)
	
	points.push_back(end_point)



func _get_default_gravity(_delta: float) -> Vector2:
	return Vector2(0., 970. * _delta)


func _enter_tree() -> void:
	_create_points()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			pass


func _physics_process(delta: float) -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	if !Engine.is_editor_hint() or (test_mode and Engine.is_editor_hint()):
		for iter: int in range(0, (step / 2.) + 2, 1):
			if iter != (step / 2.) + 1:
				var left_point: Vector2 = points[iter + 1]
				var right_point: Vector2 = points[(points.size() - 1) - (iter + 1)]
				
				#var is_left_point_is_on_floor: bool = _point_is_on_floor(left_point, space_state)
				#var is_right_point_is_on_floor: bool = _point_is_on_floor(right_point, space_state)
				#
				#if is_left_point_is_on_floor and is_right_point_is_on_floor:
					#continue # 왼쪽 포인트 오른쪽 포인트 모두 물리체와 충돌 시, 다음 루프로 건너뜀.
				
				#var 최대좌표: Vector2 = left_point if right_point.y < left_point.y else right_point
				
				var purpose_point: Vector2 = left_point + (_get_default_gravity(delta))
				
				_move_points(iter, purpose_point)
			else:
				pass

		queue_redraw()


func _move_points(_range: int, to: Vector2) -> void:
	var max_idx: int = points.size() - 1
	var mid_idx: int = int(max_idx / 2.)
	
	for i: int in range(_range + 1, max_idx - (_range + 1), 1):
		var neighbor: Vector2 = points[i - 1] if i < mid_idx else points[i + 1]
		var _dir: Vector2 = neighbor.direction_to(to)
		if neighbor.distance_squared_to(to) < dist_point_by_point() ** 2:
			points[i].y = to.y
		else:
			points[i].y = (_dir * dist_point_by_point()).y



func point_to_global(pnt: Vector2) -> Vector2:
	return pnt + global_position


# RAYCASTING
func _point_is_colliding(point: Vector2, to: Vector2, space_state: PhysicsDirectSpaceState2D) -> Dictionary:
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		point_to_global(point),
		point_to_global(to),
		mask
	)
	query.hit_from_inside = true
	
	var result: Dictionary = space_state.intersect_ray( query )

	return result


# POINT CASTING
func _point_is_on_floor(point: Vector2, space_state: PhysicsDirectSpaceState2D) -> bool:
	var p_query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	p_query.position = point_to_global(point)
	p_query.collide_with_bodies = true
	p_query.collision_mask = mask
	var p_result: Array[Dictionary] = space_state.intersect_point(p_query)
	if !p_result.is_empty():
		return true
	
	return false


func _draw() -> void:
	if points.is_empty(): return
	
	#var current_color: Color = Color(0., 0., .15, 1.)
	
	var idx: int = 1
	
	for point: Vector2 in points:
		var is_pined_point: bool = points[0] == point or points[points.size() - 1] == point
		if is_pined_point:
			draw_circle(
				point, 3., Color.WHITE
			)
		else:
			draw_circle(
				point, 3., Color.BLUE_VIOLET
			)
			
			draw_char(
				ThemeDB.fallback_font, point, str(idx), 12
			)
			
			idx += 1

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
	
	if !points_rid.is_empty():
		for rid: RID in points_rid:
			PhysicsServer2D.free_rid(rid)
