@tool
extends Node2D
class_name Hitbox


var _area: RID


@export var collider: Array[HitboxInformation]

@export var color: Color = Color(0.645, 0.82, 0.164, 0.282)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if !Engine.is_editor_hint():
				set_notify_transform(true)
				
				_area = PhysicsServer2D.area_create()
				PhysicsServer2D.area_set_space(_area, get_world_2d().space)
				PhysicsServer2D.area_set_transform(_area, get_transform())
				PhysicsServer2D.area_set_monitorable(_area, false)
				
				if !collider.is_empty():
					for collide: HitboxInformation in collider:
						collide._index = PhysicsServer2D.area_get_shape_count(_area)
						collide._shape = PhysicsServer2D.rectangle_shape_create()
						PhysicsServer2D.shape_set_data(collide._shape, collide.size)
						PhysicsServer2D.area_add_shape(_area, collide._shape, Transform2D(), collide.disabled)
				
				# attach instance to parent
				var parent: Node = get_parent()
				PhysicsServer2D.area_attach_object_instance_id(
					_area, parent.get_instance_id() if parent else get_instance_id()
				)
				
				PhysicsServer2D.area_set_area_monitor_callback(
					_area, _area_entered_exited
				)

		NOTIFICATION_EXIT_TREE:
			if !Engine.is_editor_hint():
				if !collider.is_empty():
					for collide: HitboxInformation in collider:
						PhysicsServer2D.free_rid(collide._shape)
	
				PhysicsServer2D.free_rid(_area)

		NOTIFICATION_TRANSFORM_CHANGED:
			if !Engine.is_editor_hint():
				PhysicsServer2D.area_set_transform(
					_area, get_global_transform()
				)

		NOTIFICATION_DRAW:
			if Engine.is_editor_hint():
				if !collider.is_empty():
					for collide in collider:
						if !collide.disabled:
							RenderingServer.canvas_item_add_rect(
								get_canvas_item(),
								Rect2(collide.position - (collide.size / 2.), collide.size),
								color
							)


func _area_entered_exited(
	status: PhysicsServer2D.AreaBodyStatus,
	area_rid: RID,
	instance_id: int,
	area_shape_idx: int,
	self_shape_idx: int
) -> void:
	if instance_id == get_parent().get_instance_id(): return
	
	if status == PhysicsServer2D.AREA_BODY_ADDED:
		var send: Dictionary = {}
		send["unit"] = instance_from_id(instance_id)
		send["from"] = collider[self_shape_idx]
		send["to"] = area_shape_idx
		_area_entered()
	elif status == PhysicsServer2D.AREA_BODY_REMOVED:
		_area_exited()


func remove_collider(res: CollideInfo) -> void:
	if collider.has(res):
		collider.erase(res)
	
	PhysicsServer2D.free_rid(res._shape)
	
	sort_collider(res._index)


func sort_collider(start_idx: int) -> void:
	if !Engine.is_editor_hint():
		var idx: int = start_idx

		for i: int in range(start_idx, collider.size() - 1):
			PhysicsServer2D.area_set_shape(collider[i], idx, collider[i]._shape)
			collider[i]._index = idx
			idx += 1


# OVERRIDE
func _area_entered(data: Dictionary = {}) -> void:
	print("Entered")


# OVERRIDE
func _area_exited(data: Dictionary = {}) -> void:
	pass
