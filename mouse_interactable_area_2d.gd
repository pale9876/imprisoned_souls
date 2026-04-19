@tool
extends Legion
class_name InteractableLegion


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if Input.is_action_just_pressed("click"):
		var point_param: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
		point_param.canvas_instance_id = get_canvas().get_id()
		#point_param.position = get_global_mouse_position()
		#
		#var result: Array[Dictionary] = get_world_2d().direct_space_state.intersect_point(point_param, 1)
		
		
		#if !result.is_empty():
			#pass
