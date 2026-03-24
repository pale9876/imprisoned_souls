@tool
extends Node2D
class_name AnimatedPartsModule


@export_flags_2d_physics var mask: int = 1
@export var parts: Array[AnimatedPart]
@export var auto_emit: bool = false
@export var debug_mode: bool = false
@export var init_direction: Vector2
@export var radial_range: float

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
					emit()
		
		NOTIFICATION_PHYSICS_PROCESS:
			if Engine.is_editor_hint(): return
			
			var delta: float = get_physics_process_delta_time()
			
			if _emitted and !parts.is_empty():
				var canvas_item: RID = get_canvas_item()
				
				RenderingServer.canvas_item_clear(get_canvas_item())
				
				var exclude: Array[RID] = get_parts_rids()
				
				for res: AnimatedPart in parts:
					if !res._collided:
						res.move(Vector2(1., 1.) * 970.0 * delta * .3, exclude)
					RenderingServer.canvas_item_add_rect(
						canvas_item, Rect2(res.get_position() - global_position, res.size), Color.WHITE
					)
			
		NOTIFICATION_EXIT_TREE:
			_emitted = false
			
			for res: AnimatedPart in parts:
				if !Engine.is_editor_hint():
					PhysicsServer2D.free_rid(res.get_body_rid())


func emit() -> void:
	if _emitted: return
	
	var space: RID = get_world_2d().space
	
	for res: AnimatedPart in parts:
		res.create_body(space, get_global_transform())
	
	_emitted = true


func get_parts_rids() -> Array[RID]:
	var rids: Array[RID] = []
	for res: AnimatedPart in parts:
		rids.push_back(res.get_body_rid())
	return rids
