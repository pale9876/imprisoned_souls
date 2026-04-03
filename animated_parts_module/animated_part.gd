@tool
extends Resource
class_name AnimatedPart


@export var texture: AtlasTexture
@export var position: Vector2
@export var size: Vector2 = Vector2(10., 10.)
@export var frame: Vector2
@export var frame_size: Vector2
@export var bounce: float = .45


var _body: RID
var _shape: RID
var _cid: RID
var velocity: Vector2
var _on_floor: bool = false
var _collided: bool = false
var _reminder: float = 0.
var deceleration_p_tick: float = 2260.
var last_normal: Vector2

var _sleep: bool = false
var transform: Transform2D = Transform2D()


func create_body(space: RID, tf: Transform2D, parent_cid: RID) -> void:
	transform = tf
	
	_body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_space(_body, space)
	PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_set_state(_body, PhysicsServer2D.BODY_STATE_TRANSFORM, get_transform())
	
	_shape = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.shape_set_data(_shape, size)
	PhysicsServer2D.body_add_shape(_body, _shape)
	PhysicsServer2D.body_attach_object_instance_id(_body, get_instance_id())
	
	_cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(_cid, parent_cid)
	RenderingServer.canvas_item_set_transform(_cid, get_canvas_transform())
	RenderingServer.canvas_item_add_rect(_cid, Rect2(- (size / 2.), size), Color.WHITE)


func move(value: Vector2, exclude: Array[RID] = []) -> void:
	if velocity.is_equal_approx(Vector2()):
		_sleep = true
		return
	
	var motion: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
	motion.from = get_transform()
	motion.margin = .08
	motion.motion = value
	motion.recovery_as_collision = true
	motion.exclude_bodies = exclude
	
	var result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
	var test: bool = PhysicsServer2D.body_test_motion(_body, motion, result)
	
	if !_collided:
		if test:
			position += (value * result.get_collision_unsafe_fraction())
			_collided = true
			_reminder = result.get_remainder().length()
			last_normal = result.get_collision_normal()
		else:
			position += value
	
	RenderingServer.canvas_item_set_transform(_cid, get_canvas_transform())


func get_body_rid() -> RID:
	return _body


func get_position() -> Vector2: return position


func is_on_floor() -> bool: return _on_floor


func draw() -> void:
	RenderingServer.canvas_item_add_rect(
		_cid, Rect2(Vector2(), size), Color.WHITE
	)


func get_transform() -> Transform2D:
	return Transform2D(0., transform.origin + position)

func get_canvas_transform() -> Transform2D:
	return Transform2D(0., position)
