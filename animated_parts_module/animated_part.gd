@tool
extends Resource
class_name AnimatedPart


const NOTIFICATION_TRANSFORM_CHANGED: int = 1400

@export var texture: AtlasTexture
@export var size: Vector2 = Vector2(10., 10.)
@export var frame: Vector2
@export var frame_size: Vector2


var _body: RID
var _shape: RID
var _position: Vector2
var velocity: Vector2
var _on_floor: bool = false
var _collided: bool = false


#func _notification(what: int) -> void:
	#match what:
		#NOTIFICATION_TRANSFORM_CHANGED:
			#PhysicsServer2D.body_set_state(_body, PhysicsServer2D.BODY_STATE_TRANSFORM, _get_transform())


func create_body(space: RID, tf: Transform2D) -> void:
	_position = tf.get_origin()
	
	_body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_space(_body, space)
	PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_set_state(_body, PhysicsServer2D.BODY_STATE_TRANSFORM, _get_transform())
	
	_shape = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.shape_set_data(_shape, size)

	PhysicsServer2D.body_add_shape(_body, _shape)

	PhysicsServer2D.body_attach_object_instance_id(_body, get_instance_id())


func move(value: Vector2, exclude: Array[RID] = []) -> void:
	var motion: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
	motion.from = _get_transform()
	motion.margin = 0.
	motion.motion = value
	motion.recovery_as_collision = true
	motion.exclude_bodies = exclude
	
	var result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
	var test: bool = PhysicsServer2D.body_test_motion(_body, motion, result)
	
	if !_collided:
		if test:
			var destination: Vector2 = _position + (value * result.get_collision_unsafe_fraction())
			_position = destination
			_collided = true
		else:
			_position += value
	
	notification(NOTIFICATION_TRANSFORM_CHANGED)
	
	print("_position: ", _position)


func get_body_rid() -> RID:
	return _body


func get_position() -> Vector2: return _position


func is_on_floor() -> bool: return _on_floor


func draw(canvas_item_id: RID) -> void:
	RenderingServer.canvas_item_add_rect(
		canvas_item_id, Rect2(Vector2(), size), Color.WHITE
	)
	

func _get_transform() -> Transform2D:
	return Transform2D(0., _position)

	
	
	
	
	
	
	
