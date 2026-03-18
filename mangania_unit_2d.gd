@tool
extends Node2D
class_name ManganiaUnit2D


var body_rid: RID

@export var collision_draw_up: bool = true
#@export var size: Vector2 = Vector2(10., 10.)

var collider: Array[CollideInfo]

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

			body_rid = PhysicsServer2D.body_create()
			for res: CollideInfo in collider:
				var shape_rid: RID = res.rid
				PhysicsServer2D.body_add_shape(
					body_rid,
					res.rid,
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
			var shape_transform: Transform2D = PhysicsServer2D.body_get_shape_transform(body_rid, 0)
			print(PhysicsServer2D.shape_get_data(
						PhysicsServer2D.body_get_shape(body_rid, 0)
					))
			RenderingServer.canvas_item_add_rect(
				canvas_item,
				Rect2(
					shape_transform.origin,
					PhysicsServer2D.shape_get_data(
						PhysicsServer2D.body_get_shape(body_rid, 0)
					)
				),
				color
			)

		NOTIFICATION_EXIT_TREE:
			PhysicsServer2D.free_rid(body_rid)


#func get_shape_rid(shape_name: StringName) -> RID:
	#if !collisions.has(shape_name): return RID()
	#return collisions[shape_name].get_rid()


func get_body_rid() -> RID:
	return body_rid


func create_collider(collider_name: StringName) -> void:
	var res: CollideInfo = CollideInfo.new()
	res.name = collider_name
	res.rid = PhysicsServer2D.rectangle_shape_create()
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


class CollideInfo extends RefCounted:
	var _index: int = -1
	var name: StringName = &""
	var position: Vector2 = Vector2()
	var size: Vector2 = Vector2(10., 10.)
	var disabled: bool = true
	var rid: RID
	var owner: ManganiaUnit2D


	func get_rid() -> RID: return rid
	func get_owner() -> ManganiaUnit2D: return owner
