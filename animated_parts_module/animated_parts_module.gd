@tool
extends Node2D
class_name AnimatedPartsModule


@export_flags_2d_physics var mask: int = 1
@export var parts: Array[AnimatedPart]
@export var auto_emit: bool = false
@export var init_force: float = 600.
@export var radial_range: float
@export var auto_deceleration: bool = true


var _emitted: bool = false


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass



func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if !Engine.is_editor_hint():
				if auto_emit:
					for i: int in range(300):
						parts.push_back(
							AnimatedPart.new()
						)
					
					emit()
		
		NOTIFICATION_PHYSICS_PROCESS:
			if Engine.is_editor_hint(): return
			
			var delta: float = get_physics_process_delta_time()
			
			if _emitted and !parts.is_empty():
				var exclude: Array[RID] = get_parts_rids()
				
				for res: AnimatedPart in parts:
					if !res._sleep:
						if !res._collided:
							res.move(res.velocity * delta, exclude)
							if auto_deceleration:
								res.velocity = res.velocity.move_toward(Vector2(), 350. * delta)
						else:
							if res._reminder != 0.:
								res.velocity = res.velocity.bounce(res.last_normal) * res.bounce
								res._collided = false


		NOTIFICATION_EXIT_TREE:
			_emitted = false
			
			if !Engine.is_editor_hint():
				for res: AnimatedPart in parts:
					PhysicsServer2D.free_rid(res.get_body_rid())
					RenderingServer.canvas_item_clear(get_canvas_item())


func emit(min_dir: float = -TAU, max_dir: float = TAU) -> void:
	if _emitted: return
	
	var space: RID = get_world_2d().space
	
	for res: AnimatedPart in parts:
		res.create_body(space, Transform2D(0., global_position), get_canvas_item())
		res.velocity = init_force * Vector2.from_angle(randf_range(min_dir, max_dir))
	
	_emitted = true


func get_parts_rids() -> Array[RID]:
	var rids: Array[RID] = []
	for res: AnimatedPart in parts:
		rids.push_back(res._body)
	return rids
