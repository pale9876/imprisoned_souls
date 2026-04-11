@tool
extends Node2D


const NOTIFICATION_COLLIDER_CHANGED: int = 24000


@export var collider: Array[HurtboxInformation]

@export var color: Color = Color(0.73, 0.329, 0.329, 0.255)


var _area: RID


func change_collider(info_name: StringName) -> bool:
	var result: bool = false
	
	for collide in collider:
		collide.disabled = collide.name == info_name
		result = true
	
	notification(NOTIFICATION_COLLIDER_CHANGED)

	return result


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if !Engine.is_editor_hint():
				set_notify_transform(true)
				
				var space_rid: RID = get_world_2d().space
				
				_area = PhysicsServer2D.area_create()
				PhysicsServer2D.area_set_space(_area, space_rid)
				PhysicsServer2D.area_set_monitorable(_area, true)
				PhysicsServer2D.area_set_transform(_area, get_transform())

				for collide in collider:
					collide._index = PhysicsServer2D.area_get_shape_count(_area)
					collide._shape = PhysicsServer2D.rectangle_shape_create()
					PhysicsServer2D.area_add_shape(
						_area, collide._shape, Transform2D()
					)

				var parent: Node = get_parent()
				PhysicsServer2D.area_attach_object_instance_id(
					_area, parent.get_instance_id() if parent else get_instance_id()
				)

		NOTIFICATION_DRAW:
			draw_area()

		NOTIFICATION_COLLIDER_CHANGED:
			if !Engine.is_editor_hint():
				draw_area()


		NOTIFICATION_TRANSFORM_CHANGED:
			if !Engine.is_editor_hint():
				PhysicsServer2D.area_set_transform(_area, get_global_transform())
		
		
		NOTIFICATION_EXIT_TREE:
			if !Engine.is_editor_hint():
				PhysicsServer2D.free_rid(_area)


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

func draw_area() -> void:
	if (Engine.is_editor_hint() or (!Engine.is_editor_hint() and ProjectSettings.get("global/draw_hurtbox"))):
		for collide in collider:
			if !collide.disabled:
				RenderingServer.canvas_item_add_rect(
					get_canvas_item(), Rect2(- (collide.size / 2.), collide.size), color
				)
