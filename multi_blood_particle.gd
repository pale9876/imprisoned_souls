@tool
extends Node2D
class_name MultiBloodParticle


@export var texture: Texture2D
@export var multimesh: MultiMesh = MultiMesh.new()


var arr: Array[P] = []


func emit(bpi: BloodParticleInformation, pos: Vector2) -> void:
	var p: P = P.new()
	
	p.cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(p.cid, get_canvas_item())
	
	p.multimesh = MultiMesh.new()
	p.multimesh.mesh = QuadMesh.new()
	var sz: float = randf_range(bpi.min_size, bpi.max_size)
	(p.multimesh.mesh as QuadMesh).size = Vector2(sz, sz)
	
	p.multimesh.instance_count = bpi.amount
	p.multimesh.visible_instance_count = bpi.amount - 1
	
	RenderingServer.canvas_item_add_multimesh(
		p.cid, multimesh.get_rid(), texture.get_rid()
	)
	
	p.instances.resize(bpi.amount)
	
	for i: int in range(bpi.amount):
		var instance: P.I = P.I.new()
		instance.motion = Vector2.from_angle(
			randf_range(bpi.direction.angle() - deg_to_rad(bpi.angle_range), bpi.direction.angle() + deg_to_rad(bpi.angle_range))
		) * randf_range(bpi.min_force, bpi.max_force)
		
		p.instances[i] = instance
		
	
	arr.push_back(p)


func _exit_tree() -> void:
	if !arr.is_empty():
		for p: P in arr:
			RenderingServer.free_rid(p.cid)


class P extends RefCounted:
	var cid: RID
	var multimesh: MultiMesh
	var instances: Array[I]
	var info: BloodParticleInformation

	func next() -> void:
		for inst: I in instances:
			inst.position += inst.motion
			info.curve


	class I extends RefCounted:
		var idx: int
		var motion: Vector2
		var position: Vector2
