@tool
extends CharacterBody2D
class_name PhysicsUnit2D

@export var _information: UnitInformation
@export_flags_2d_physics var init_mask: int = 0
@export var pose_controller: PoseController2D
@export var init_collider: CollisionShape2D

var _collider: Dictionary[StringName, CollisionShape2D] = {}

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_DEFAULT)
var _current: CollisionShape2D = null


var _on_floor: bool = false
var _on_ceil: bool = false
var _on_wall: bool = false


func get_information() -> UnitInformation:
	return _information


func _init() -> void:
	motion_mode = MOTION_MODE_GROUNDED
	up_direction = Vector2.UP
	collision_layer = 0


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		_current = init_collider


func _update() -> void:
	_collider.clear()
	
	for node: Node in get_children():
		if node is CollisionShape2D:
			_collider[node.name] = node


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		_update()


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or _current == null: return

	if _on_floor:
		#if velocity.y > 0.:
		_on_floor = snap_on_floor()
	#else:
		#velocity.y += 970. * delta
		#print("get_gravity")
		#print(velocity)

	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		var collide_object: Object = collision.get_collider()
		if collide_object is PhysicsUnit2D:
			_collide_ev_handler(collision)
		else:
			_slide(collision, delta)


func snap_on_floor() -> bool:
	if velocity.y < 0.: return false
	
	var result: KinematicCollision2D = move_and_collide(
		Vector2(0., 1.) * floor_snap_length, true, safe_margin, false
	)
	
	if result:
		#global_position.y = result.get_position().y
		return true
	
	return false



# OVERRIDE
func _collide_ev_handler(_collision: KinematicCollision2D) -> void:
	pass


func _change_init_collider() -> void:
	pass


func find_collider(node_name: StringName) -> int:
	for node: Node in get_children():
		pass
	
	var result: int = get_children().find_custom(
		func(node: Node) -> bool:
			return node.name == node_name
	)
	return result


#func _is_colliding_with_floor() -> bool:
	#var shape_cast_param: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	#shape_cast_param.collide_with_bodies = true
	#shape_cast_param.collision_mask = _mask
	#shape_cast_param.motion = Vector2(0., floor_snap_length)
	#shape_cast_param.shape = _current.shape
#
	#var result: Array[Dictionary] = get_world_2d().direct_space_state.intersect_shape(
		#shape_cast_param
	#)
#
	#return !result.is_empty()


# OVERRIDE
func _slide(_collision: KinematicCollision2D, delta: float) -> void:
	var _normal: Vector2 = _collision.get_normal()
	var _remainder: Vector2 = _collision.get_remainder()
	
	if motion_mode == MOTION_MODE_GROUNDED:
		if _collision.get_angle(up_direction) <= floor_max_angle + .01:
			_on_floor = true
			#print("Floor")
		elif _collision.get_angle(- up_direction) <= floor_max_angle + .01:
			_on_ceil = true
			#print("Ceil")
		else:
			_on_wall = true
			#print("Wall")

	_remainder = velocity.slide(_normal)
	
	var _remainder_collision: KinematicCollision2D = move_and_collide(_remainder * delta)


func get_collider_list() -> PackedStringArray:
	var result: PackedStringArray = []
	
	for node: Node in get_children():
		if node is CollisionShape2D:
			result.push_back(node.name)

	return result


func change_collider(c_name: String) -> bool:
	if !get_collider_list().has(c_name):
		return false
	
	for collider: CollisionShape2D in _collider.values():
		if collider.name == c_name:
			collider.visible = true
		else:
			collider.visible = false
	
	return true
