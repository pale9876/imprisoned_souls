@tool
extends Node2D
class_name ManganiaUnit2D


const NOTIFICATION_COLLIDER_CHANGED: int = 2101
const NOTIFICATION_MASK_CHANGED: int = 2102
const NOTIFICAITON_LAYER_CHANGED: int = 2013


var _body: RID
var _collided: bool = false


@export var collision_draw_up: bool = true:
	set(toggle):
		collision_draw_up = toggle
		queue_redraw()

@export var collider: Array[CollideInfo]
var _current: CollideInfo = null:
	set(_collider):
		_current = _collider
		notification(NOTIFICATION_COLLIDER_CHANGED)

@export var color: Color = Color(0.647, 0.529, 0.847, 0.89):
	set(_color):
		color = _color
		#if _owner is ManganiaUnit2D:
			#_draw(_owner.get_canvas_item(), _owner.color)

@export_flags_2d_physics var mask: int = 1
@export_flags_2d_physics var layer: int = 1


@export_group("DEBUG")
@export var draw_collider: bool = true:
	set(toggle):
		draw_collider = toggle
		queue_redraw()


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
			set_notify_transform(true)
			set_notify_local_transform(true)
			
			var space: RID = get_world_2d().space
			_body = PhysicsServer2D.body_create()

			if !collider.is_empty():
				update_shapes()

			PhysicsServer2D.body_set_space(_body, space)
			PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_KINEMATIC)
			PhysicsServer2D.body_set_state(
				_body, PhysicsServer2D.BODY_STATE_TRANSFORM, get_global_transform()
			)

			# Set Collision Layer & Mask
			PhysicsServer2D.body_set_collision_layer(_body, layer)
			PhysicsServer2D.body_set_collision_mask(_body, mask)
			
			# Attach body to object
			PhysicsServer2D.body_attach_object_instance_id(_body, get_instance_id())
			PhysicsServer2D.body_attach_canvas_instance_id(get_body_rid(), get_instance_id())

		NOTIFICATION_DRAW:
			#if Engine.is_editor_hint():
			if draw_collider:
				if collider.is_empty(): return
					
				RenderingServer.canvas_item_clear(get_canvas_item())
					
				for info: CollideInfo in collider:
					if !info.disabled:
						info._draw(get_canvas_item(), color)
				
				draw_circle(
					PhysicsServer2D.body_get_state(_body, PhysicsServer2D.BODY_STATE_TRANSFORM).origin - global_position,
					3.,
					Color.RED
				)

		NOTIFICATION_COLLIDER_CHANGED:
			PhysicsServer2D.body_clear_shapes(_body)
			
			if !collider.is_empty():
				update_shapes()


		NOTIFICATION_EXIT_TREE:
			for info: CollideInfo in collider:
				PhysicsServer2D.free_rid(info._shape)
			
			PhysicsServer2D.free_rid(_body)

			RenderingServer.canvas_item_clear(get_canvas_item())


func update_shapes() -> void:
	for res: CollideInfo in collider:
		res._shape = PhysicsServer2D.rectangle_shape_create()
		var shape_rid: RID = res._shape
		
		PhysicsServer2D.body_add_shape(
			_body,
			res._shape,
			Transform2D(),
			false
		)
		PhysicsServer2D.shape_set_data(shape_rid, res.size)


func _move(motion: Vector2, exclude: Array[RID] = []) -> void:
	var param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
	var result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()

	param.exclude_bodies = exclude
	param.from = get_global_transform()
	param.motion = motion
	param.recovery_as_collision = true
	param.collide_separation_ray = true

	var test: bool = PhysicsServer2D.body_test_motion(_body, param, result)

	if test:
		var object: Object = result.get_collider()
		var safe_fraction: float = result.get_collision_safe_fraction()
		var unsafe_fraction: float = result.get_collision_unsafe_fraction()
		var collide_point: Vector2 = result.get_collision_point()
		var depth: float = result.get_collision_depth()
		var normal: Vector2 = result.get_collision_normal()
		#var resolve: float = unsafe_fraction - safe_fraction
		
		global_position += motion * unsafe_fraction
	else:
		global_position += motion


func snap_to_normal() -> void:
	pass


func _update_collider() -> void:
	pass



func get_body_rid() -> RID:
	return _body



func create_collider(collider_name: StringName) -> void:
	var res: CollideInfo = CollideInfo.create(collider_name)
	res._index = collider.size()
	collider.push_back(res)


func remove_collider(index: int) -> bool:
	if !collider.get(index): return false
	
	var res: CollideInfo = collider[index]
	
	res.remove()
	
	collider.erase(res)

	_update_collider_index()

	return true


func _update_collider_index() -> void:
	var index: int = 0
	
	for res: CollideInfo in collider:
		PhysicsServer2D.body_set_shape(
			_body, index, res.rid
		)
		index += 1
