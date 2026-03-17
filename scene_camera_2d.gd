@tool
extends Camera2D
class_name SceneCamera2D


@export var move_per_second: float = 330.
@export var target: Node2D = null


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PROCESS:
			if Engine.is_editor_hint(): return
			
			var delta: float = get_process_delta_time()
			
			if target != null:
				var target_pos: Vector2 = target.global_position
				global_position = global_position.move_toward(target_pos, move_per_second * delta)

# OVERRIDE
func _process(delta: float) -> void:
	pass


func _shake() -> void:
	pass
