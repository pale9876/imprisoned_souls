@tool
extends Resource
class_name SquadMember


const NOTIFICATION_SIZE_CHANGED: int = 1500
const NOTIFICATION_AWAKEND: int = 1501
const NOTIFICATION_CAUTION_SIGNAL: int = 1502
const NOTIFICATION_TRANSFORM_CHANGED: int = 1503


@export var size: Vector2 = Vector2(10., 10.):
	set(value):
		size = value
		notification(NOTIFICATION_SIZE_CHANGED)
@export var position: Vector2 = Vector2()
@export var scope_range: Vector2 = Vector2(200., 100.)
@export var direction: float = 1.

@export_flags_2d_physics var mask: int = 1
@export_flags_2d_physics var layer: int = 0

@export var draw_up: bool = true

var _body: RID
var _shape: RID

var _hurtbox: RID
var _hbox_shape: RID

var _awareness: RID
var _aw_shape: RID


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SIZE_CHANGED:
			if _shape.is_valid():
				PhysicsServer2D.shape_set_data(_shape, size)
				PhysicsServer2D.body_set_shape_transform(
					_body, 0, Transform2D(0., Vector2(0., - size.y / 2. if draw_up else 0.))
				)

		NOTIFICATION_TRANSFORM_CHANGED:
			PhysicsServer2D.area_set_transform(_hurtbox, get_transform())
			PhysicsServer2D.area_set_transform(_awareness, get_transform())


func move(dir: Vector2, toward: Vector2) -> void:
	pass


func create(space: RID, init_pos: Vector2) -> SquadMember:
	var member: SquadMember = SquadMember.new()
	create_body(space, init_pos)
	return member

func remove() -> void:
	pass


func create_body(space: RID, init_pos: Vector2) -> void:
	position = init_pos
	
	_body = PhysicsServer2D.body_create()
	_shape = PhysicsServer2D.rectangle_shape_create()
	
	PhysicsServer2D.body_set_space(space, _body)
	PhysicsServer2D.body_set_mode(_body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_set_state(_body, PhysicsServer2D.BODY_STATE_TRANSFORM, get_transform())
	
	PhysicsServer2D.shape_set_data(_shape, size)
	
	PhysicsServer2D.body_add_shape(
		_body, _shape, Transform2D(0., Vector2(0., - size.y / 2. if draw_up else 0.))
	)
	
	PhysicsServer2D.body_attach_object_instance_id(_body, get_instance_id())


func create_hurtbox(space: RID) -> void:
	_hurtbox = PhysicsServer2D.area_create()
	_hbox_shape = PhysicsServer2D.rectangle_shape_create()
	
	PhysicsServer2D.area_set_space(_hurtbox, space)
	PhysicsServer2D.area_set_collision_layer(_hurtbox, mask)
	PhysicsServer2D.area_set_monitorable(_hurtbox, true)
	
	PhysicsServer2D.area_add_shape(
		_hurtbox,
		_hbox_shape,
		Transform2D(0., Vector2(0., - size.y / 2. if draw_up else 0.))
	)

	PhysicsServer2D.area_attach_object_instance_id(_hurtbox, get_instance_id())


func create_awareness(space: RID) -> void:
	_awareness = PhysicsServer2D.area_create()
	_aw_shape = PhysicsServer2D.rectangle_shape_create()
	
	PhysicsServer2D.area_set_space(_awareness, space)
	PhysicsServer2D.area_set_transform(_awareness, get_transform())
	
	PhysicsServer2D.area_add_shape(_awareness, _aw_shape, Transform2D(0., Vector2()))
	PhysicsServer2D.shape_set_data(_aw_shape, scope_range)
	
	PhysicsServer2D.area_attach_object_instance_id(_awareness, get_instance_id())



func draw_hurtbox(canvas_item: RID) -> void:
	pass


func draw_awareness(canvas_item: RID) -> void:
	pass


func draw_body(canvas_item: RID) -> void:
	pass


func notify_message(message: String, data: Dictionary) -> void:
	pass


func get_transform() -> Transform2D:
	return Transform2D(0., position)


func get_gravity(delta: float) -> Vector2:
	return Vector2.DOWN * 970. * delta
