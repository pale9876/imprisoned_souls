@tool
extends MultiMeshInstance2D
class_name PhysicsParticle2D


enum Mode {
	KINEMATIC = PhysicsServer2D.BodyMode.BODY_MODE_KINEMATIC,
	RIGID = PhysicsServer2D.BodyMode.BODY_MODE_RIGID
}


@export var mode: Mode = Mode.KINEMATIC
@export var radius: float = 5.
@export var hsplit: int = 1
@export var vsplit: int = 1


var _objs: Array[Object]


var id: int = -1:
	get():
		id += 1
		return id


func init_id() -> void:
	id = -1


func _add_obj() -> void:
	if texture:
		var particle: Particle = Particle.new(
			id, Vector2i.ZERO, Vector2i(64, 64), radius,
			mode as PhysicsServer2D.BodyMode,
			get_world_2d().direct_space_state
		)


func _physics_process(delta: float) -> void:
	for obj: Particle in _objs:
		_move_particle(obj, delta)


func _move_particle(obj: Particle, delta: float) -> void:
	var motion_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
	motion_param.from = Transform2D(0., obj.pos)
	motion_param.margin = .5
	motion_param.motion = obj.force * delta
	
	var result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
	
	var collide: bool = PhysicsServer2D.body_test_motion(
		obj._rid,
		motion_param,
		result
	)

	if collide:
		print("---------------!!collide!!------------------")
		print(result.get_collider())
		print(result.get_collision_point())
		print(result.get_collision_normal())
		print("--------------------------------------------")
		
		obj._collided = true
		
		obj.pos = result.get_collision_point() + (result.get_collision_normal() * obj._radius)
		obj.force = obj.force.bounce(result.get_collision_normal())
	else:
		obj.pos += motion_param.motion


func _collide_handler(id: int, velocity: Vector2, normal: Vector2) -> void:
	pass


class Particle extends Object:
	var rid: RID
	var instance_id: int = -1
	var coord: Vector2i = Vector2i.ZERO
	var size: Vector2i = Vector2i.ZERO
	var velocity: Vector2 = Vector2.ZERO
	var shape: CircleShape2D = null
	
	
	func set_instance_coord(value: Vector2i) -> void:
		coord = value
	
	
	func _init(
		_id: int, _coord: Vector2i, _size: Vector2i, _radius: float,
		_mode: PhysicsServer2D.BodyMode,
		_space: PhysicsDirectSpaceState2D
		) -> void:
		
		var body_rid: RID = PhysicsServer2D.body_create()
		shape = CircleShape2D.new()
		
		rid = body_rid
		shape.radius = _radius
		
		PhysicsServer2D.body_set_mode(rid, _mode)
		PhysicsServer2D.body_add_shape(
			rid, shape.get_rid(), Transform2D(0., Vector2.ONE, 0., Vector2.ZERO)
		)
		PhysicsServer2D.body_set_space(rid, _space)


	func _notification(what: int) -> void:
		if what == NOTIFICATION_PREDELETE:
			_free()


	func _free() -> void:
		PhysicsServer2D.free_rid(shape.get_rid())
		PhysicsServer2D.free_rid(rid)


	func move() -> void:
		pass
	
	
	func get_rid() -> RID: return rid
	func get_id() -> int: return instance_id
