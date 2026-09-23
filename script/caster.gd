extends RefCounted
class_name Caster



var result: Dictionary = {}


static func casting(
	from: Node2D, to: Node2D, mask: int, exclude: Array[RID]
	) -> Caster:
	var caster := Caster.new()
	
	var direct_space_state: PhysicsDirectSpaceState2D = from.get_world_2d().direct_space_state
	var param := PhysicsRayQueryParameters2D.create(
		from.global_position,
		to.global_position,
		mask, exclude
	)
	
	caster.result = direct_space_state.intersect_ray(param)
	return caster


func shape_cast(
	from_area: Node2D, to_body: Node2D, shape: Shape2D, mask: int, exclude: Array[RID]
	) -> Dictionary:
	var direct_space_state: PhysicsDirectSpaceState2D = from_area.get_world_2d().direct_space_state
	var shape_query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	var ray_motion: Vector2 = from_area.global_position.direction_to(to_body.global_position) * from_area.global_position.distance_to(to_body.global_position)
	
	shape_query.motion = ray_motion
	shape_query.collide_with_areas = true
	shape_query.shape = shape
	shape_query.transform = from_area.get_global_transform()
	shape_query.collision_mask = mask
	shape_query.exclude = exclude
	
	return direct_space_state.get_rest_info(shape_query)


func ray_is_colliding(
	from: Node2D, to: Node2D, mask: int, exclude: Array[RID]
	) -> bool:
	
	var cast := casting(from, to, mask, exclude)
	if !cast.is_empty():
		var collider := cast["collider"] as Node2D
		return collider == to
	
	return false


func shape_is_colliding(
	from_area: Node2D, to_body: Node2D, shape: Shape2D, mask: int, exclude: Array[RID]
) -> bool:
	
	var cast: Dictionary = shape_cast(from_area, to_body, shape, mask, exclude)
	if !cast.is_empty():
		var collider_id := cast["collider_id"] as int
		return to_body.get_instance_id() == collider_id

	return false


	
