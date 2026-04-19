@tool
extends EEAD
class_name MultiBloodParticle


@export var texture: GradientTexture2D

@export_category("Blood Stream Particle Information")
@export var has_stream: bool = false
@export var amount: int = 10

@export_category("Size Range")
@export var max_size: float = 5.
@export var min_size: float = 1.

@export_category("Init Force Range")
@export var max_force: float = 300.
@export var min_force: float = 0.

@export_category("Direction")
@export var direction: Vector2 = Vector2.RIGHT:
	get:
		return direction.normalized() if !direction.is_normalized() else direction

@export var angle_range: float = 30.:
	set(value):
		angle_range = value

@export_category("Tween / Curve")
@export var curve: float = .311
@export var scale_curve: Curve = Curve.new()


var arr: Array[Particle] = []


func create() -> void:
	if init:
		kill()
	
	if Engine.is_editor_hint():
		print("Execute")
		emit(Vector2())
	
	init = true


func kill() -> void:
	if !arr.is_empty():
		for particle: Particle in arr:
			RenderingServer.free_rid(particle.cid)
			

func emit(pos: Vector2) -> void:
	var p: Particle = Particle.new()
	
	p.init_pos = pos
	p.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(p.cid, get_canvas_item())
	RenderingServer.canvas_item_set_transform(p.cid, Transform2D(0., p.init_pos))
	
	p.multimesh = MultiMesh.new()
	p.multimesh.mesh = QuadMesh.new()
	(p.multimesh.mesh as QuadMesh).size = texture.get_size()
	p.multimesh.use_colors = true
	
	p.multimesh.instance_count = amount
	p.multimesh.visible_instance_count = amount
	
	p.instances.resize(amount)
	
	for i: int in range(amount):
		var instance: Instance = Instance.new()
		instance.cid = p.cid
		instance.index = i
		instance.motion = Vector2.from_angle(
			randf_range(direction.angle() - deg_to_rad(angle_range), direction.angle() + deg_to_rad(angle_range))
		) * randf_range(min_force, max_force)
		instance.position = instance.motion
		
		p.multimesh.set_instance_transform_2d(instance.index, Transform2D(0., Vector2.ONE * randf_range(min_size, max_size), 0., instance.position))
		p.multimesh.set_instance_color(instance.index, Color.WHITE)
		
		p.instances[i] = instance
	
	RenderingServer.canvas_item_add_multimesh(p.cid, p.multimesh.get_rid(), texture.get_rid())
	
	arr.push_back(p)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass



func _exit_tree() -> void:
	if init:
		kill()


class Particle extends RefCounted:
	var cid: RID
	var init_pos: Vector2
	var multimesh: MultiMesh
	var instances: Array[Instance] = []
	var finished: bool = false


class Instance extends RefCounted:
	var cid: RID
	var index: int
	var motion: Vector2
	var position: Vector2
	var motion_curve: Vector2
	var scale_curve: Vector2
	var stream: BloodStream

	func create_stream(pos: Vector2, mass: float) -> void:
		stream = BloodStream.new()
		


class BloodStream extends RefCounted:
	var pos: Vector2
	var mass: float
