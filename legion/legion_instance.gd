extends RefCounted
class_name LegionInstance

#
#var cid: RID
#var body: RID
#var shape: RID
#var space: RID
#var agent: RID
#var hurtbox: Hurtbox
#var awareness: Awareness
#var position: Vector2
#var size: Vector2
#var layer: int = 1
#var mask: int = 1
#var frame: int = 0
#var bt: BehaviorTree
#var stat: Stat
#var last_direction: Vector2
#var hitbox: Hitbox
#var z_value: float = 0.
	#
	#
#func create_hitbox(direction: Vector2) -> void:
	#hitbox.rid = PhysicsServer2D.area_create()
	#PhysicsServer2D.area_set_space(hitbox.rid, space)
	#PhysicsServer2D.area_set_transform(hitbox.rid, Transform2D(0., position + (direction * hitbox.range)))
	#PhysicsServer2D.area_set_area_monitor_callback(hitbox.rid, hit)
	#PhysicsServer2D.area_set_collision_mask(hitbox.rid, 1)
	#
	#hitbox.shape = PhysicsServer2D.rectangle_shape_create()
	#PhysicsServer2D.shape_set_data(hitbox.shape, hitbox.size / 2.)
	#PhysicsServer2D.area_add_shape(hitbox.rid, hitbox.shape)
	#
	#PhysicsServer2D.area_attach_object_instance_id(hitbox.rid, get_instance_id())
	#RenderingServer.canvas_item_set_transform(hitbox.cid, Transform2D(0., position + (direction * hitbox.range)))
	#RenderingServer.canvas_item_add_rect(
		#hitbox.cid, Rect2(- hitbox.size / 2., hitbox.size), Color.RED
	#)
#
#func kill_hitbox() -> void:
		#PhysicsServer2D.free_rid(hitbox.rid)
		#PhysicsServer2D.free_rid(hitbox.shape)
		#
		#RenderingServer.canvas_item_clear(hitbox.cid)
		#hitbox.result = null
#
#
#func move(motion: Vector2 = Vector2(), space: RID = RID()) -> MotionResult:
	#var motion_result: MotionResult
	#
	#var direct_space: PhysicsDirectSpaceState2D = PhysicsServer2D.space_get_direct_state(space)
	#var shape_param: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	#shape_param.collide_with_areas = true
	#shape_param.collide_with_bodies = false
	#shape_param.shape_rid = shape
	#shape_param.motion = motion
		#
	#var rest_info: Dictionary = direct_space.get_rest_info(shape_param)
	#var cast_motion: PackedFloat32Array = direct_space.cast_motion(shape_param)
	#
	#var safe_distance: float = cast_motion[0]
	#var unsafe_distance: float = cast_motion[1]
	#
	#if !rest_info.is_empty():
		#motion_result = MotionResult.new()
		#motion_result.collider = instance_from_id(rest_info["collider_id"] as int)
		#motion_result.normal = rest_info["normal"] as Vector2
		#motion_result.point = rest_info["point"] as Vector2
	#else:
		#position += motion
	#
	#return motion_result
#
#
#func hit(status: PhysicsServer2D.AreaBodyStatus, area_rid: RID, instance_id: int, area_shape_idx: int, self_shape_idx: int) -> void:
	#if status == PhysicsServer2D.AreaBodyStatus.AREA_BODY_ADDED:
		#var obj: Object = instance_from_id(instance_id)
		#if obj is Player and !hitbox.result:
			#obj.damaged(hitbox.damage)
			#hitbox.result = HitResult.new()
			#hitbox.result.hit = true
