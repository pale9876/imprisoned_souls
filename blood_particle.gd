@tool
extends Node2D
class_name BloodParticle

@export var information: BloodParticleInformation

@export_tool_button("Emit","2D") var _emit: Callable = emit

@export var color: Color = Color.WHITE

var arr: Array[P] = []


var _finished: bool = false


func emit() -> void:
	_finished = false
	
	if !arr.is_empty():
		kill()
		arr = []
	
	for i: int in range(information.amount):
		arr.resize(information.amount)
		
		var cid: RID = RenderingServer.canvas_item_create()
		RenderingServer.canvas_item_set_parent(cid, get_canvas_item())
		var p: P = P.new()
		p.rid = cid
		p.pos = Vector2()
		p.weight = randf_range(information.min_size, information.max_size)
		p.velocity = (
			Vector2.from_angle(
					randf_range(information.direction.angle() - information.angle_range / 2., information.direction.angle() + information.angle_range / 2.)
				)
			) * randf_range(information.min_force, information.max_force)
		p.curve = maxf(.155, randf_range(p.curve - .1, p.curve + 1.))
		
		RenderingServer.canvas_item_add_circle(
			p.rid, p.pos, p.weight, color
		)
		
		arr.set(i, p)


func kill() -> void:
	for p in arr:
		RenderingServer.free_rid(p.rid)


func _process(delta: float) -> void:
	if !_finished:
		if !arr.is_empty():
			var result: bool = false
			for p in arr:
				if !p.finish:
					if !p.velocity.is_equal_approx(Vector2()):
						var forced: Vector2 = p.pos + (p.velocity / p.weight)
						RenderingServer.canvas_item_set_transform(
							p.rid, Transform2D(0., Vector2.ONE, 0., forced)
						)
						p.pos = forced
						p.velocity = p.velocity.lerp(
							Vector2(), p.curve
						)
						result = true
					else:
						p.finish = true
				
			if !result:
				_finished = true


func _exit_tree() -> void:
	kill()


class P extends RefCounted:
	var rid: RID
	var velocity: Vector2
	var pos: Vector2
	var finish: bool = false
	var weight: float = 1.
	var curve: float = .155


class Stream extends RefCounted:
	pass
