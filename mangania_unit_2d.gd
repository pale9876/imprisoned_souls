@tool
extends Node2D
class_name ManganiaUnit2D


var body_rid: RID

@export var collision_draw_up: bool = true

@export var collider: Array[CollideInfo]

@export var color: Color = Color(0.647, 0.529, 0.847, 0.89)

@export_flags_2d_physics var mask: int = 1
@export_flags_2d_physics var layer: int = 1


# OVERRIDE
func _process(delta: float) -> void:
	pass


# OVERRIDE
func _physics_process(delta: float) -> void:
	pass


#OVERRIDE
func _draw() -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			var space: RID = get_world_2d().space

			create_body_rid()
			PhysicsServer2D.body_attach_object_instance_id(body_rid, get_instance_id())

			if !collider.is_empty():
				for res: CollideInfo in collider:
					res.shape_rid = PhysicsServer2D.rectangle_shape_create()
					var shape_rid: RID = res.shape_rid
					
					PhysicsServer2D.body_add_shape(
						body_rid,
						res.shape_rid,
						get_global_transform() if !collision_draw_up else Transform2D(0., Vector2.ONE, 0., - res.position),
						false
					)
					PhysicsServer2D.shape_set_data(shape_rid, res.size)

			PhysicsServer2D.body_set_space(body_rid, space)
			PhysicsServer2D.body_set_mode(body_rid, PhysicsServer2D.BODY_MODE_KINEMATIC)
			PhysicsServer2D.body_set_state(
				body_rid, PhysicsServer2D.BODY_STATE_TRANSFORM, get_global_transform()
			)

			# Set Collision Layer & Mask
			PhysicsServer2D.body_set_collision_layer(body_rid, layer)
			PhysicsServer2D.body_set_collision_mask(body_rid, mask)

		NOTIFICATION_DRAW:
			var canvas_item: RID = get_canvas_item()
			var shape_count: int = PhysicsServer2D.body_get_shape_count(body_rid)
			if shape_count > 0:
				for i: int in range(shape_count):
					var shape_data: Variant = (PhysicsServer2D.shape_get_data(
						PhysicsServer2D.body_get_shape(body_rid, i))
					)
					
					var shape_xform: Transform2D = PhysicsServer2D.body_get_shape_transform(body_rid, i)
					var shape_pos: Vector2 = shape_xform.origin
					
					draw_rect(Rect2(shape_pos, shape_data), color)


		NOTIFICATION_TRANSFORM_CHANGED:
			pass


		NOTIFICATION_EXIT_TREE:
			PhysicsServer2D.free_rid(body_rid)


func get_body_rid() -> RID:
	return body_rid


func create_body_rid() -> RID:
	var rid: RID = PhysicsServer2D.body_create()
	body_rid = rid
	return body_rid


func create_collider(collider_name: StringName) -> void:
	var res: CollideInfo = CollideInfo.new()
	res.name = collider_name
	res.shape_rid = PhysicsServer2D.rectangle_shape_create()
	res.owner = self
	res._index = collider.size()

	collider.push_back(res)


func remove_collider(index: int) -> bool:
	if !collider.get(index): return false
	
	var res: CollideInfo = collider[index]
	
	PhysicsServer2D.body_remove_shape(owner.get_body_rid(), index)
	PhysicsServer2D.free_rid(res.rid)
	
	collider.erase(res)

	_update_collider_index()

	return true


func _update_collider_index() -> void:
	var index: int = 0
	
	for res: CollideInfo in collider:
		PhysicsServer2D.body_set_shape(
			body_rid, index, res.rid
		)
		index += 1
