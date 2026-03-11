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

@export_tool_button("Restore", "Node") var _restore: Callable = func() -> void: _create_points(); queue_redraw();

func dist_point_by_point() -> float:
	return length / float(step + 1)


func _양_끝점의_길이() -> float:
	return sqrt(start_point.distance_squared_to(end_point))


func _create_points() -> void:
	points.clear()
	
	points.push_back(start_point)
	
	var pnt_dist_step: Vector2 = (start_point.direction_to(end_point) * _양_끝점의_길이()) / (float(step) + 1.)
	
	for i: int in range(1, step + 1, 1):
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


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			pass


func _physics_process(delta: float) -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	if !Engine.is_editor_hint() or (test_mode and Engine.is_editor_hint()):
		if state == State.CAST:
			for i: int in range(1, step + 1, 1):
				var current_pnt: Vector2 = points[i]
				var left_pnt: Vector2 = points[i - 1]
				var right_pnt: Vector2 = points[i + 1]
				var dist_to_left_pnt: float = current_pnt.distance_squared_to(left_pnt)
				var dist_to_right_pnt: float = current_pnt.distance_squared_to(right_pnt)
				var dist_pbp: float = dist_point_by_point()
				
				var current_position_is_left: bool = i < (step / 2. + 1)
				var current_position_is_middle: bool = i == step / 2. + 1
				var current_position_is_right: bool = i > step / 2. + 1
				
				var is_current_dist_less_by_left: bool = dist_to_left_pnt < dist_pbp ** 2
				var is_current_dist_less_by_right: bool = dist_to_right_pnt < dist_pbp ** 2
				
				if !_point_is_on_floor(points[i], space_state) and (is_current_dist_less_by_left or is_current_dist_less_by_right):
					var current_pos: Vector2 = global_position + points[i]
					var next_pos: Vector2 = current_pos + _get_default_gravity(delta)
					
					if current_position_is_left:
						var direction: Vector2 = current_pos.direction_to(next_pos)
						if left_pnt.distance_squared_to(next_pos) > dist_pbp ** 2:
							var _fixed_pos: Vector2 = direction * dist_pbp
							next_pos = _fixed_pos
						
						if right_pnt.distance_squared_to(next_pos) < dist_pbp ** 2:
							var right_pnt_global_pos: Vector2 = right_pnt + global_position
							var current_dist: float = right_pnt_global_pos.distance_to(next_pos)
							direction = right_pnt_global_pos.direction_to(next_pos)
							var _fixed_pos: Vector2 = direction * (dist_pbp - current_dist)
							next_pos += _fixed_pos
					elif current_position_is_right:
						pass
					
					var ray_result: Dictionary = _point_is_colliding(current_pos, next_pos, space_state)
					
					if !ray_result.is_empty():
						var collide_point: Vector2 = ray_result.position
						var normal: Vector2 = ray_result.normal
						var reminder: Vector2 = current_pos - next_pos
						
					else:
						points[i] = next_pos
					
	
		queue_redraw()

# RAYCASTING
func _point_is_colliding(current_point: Vector2, purposing_position: Vector2, space_state: PhysicsDirectSpaceState2D) -> Dictionary:
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		current_point, purposing_position, mask
	)
	query.hit_from_inside = true
	
	var result: Dictionary = space_state.intersect_ray( query )

	return result
	

# POINT CASTING
func _point_is_on_floor(pnt: Vector2, space_state: PhysicsDirectSpaceState2D) -> bool:
	var p_query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	p_query.position = pnt
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
	
	for rid: RID in points_rid:
		PhysicsServer2D.free_rid(rid)
