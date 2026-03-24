@tool
extends Camera2D
class_name SceneCamera2D


@export var follow_curve: float = .135
@export var target: Node2D = null: set = set_target


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if target:
				global_position = target.global_position
		
		NOTIFICATION_PROCESS:
			if Engine.is_editor_hint(): return
			
			var delta: float = get_process_delta_time()
			
			if target != null:
				var target_pos: Vector2 = target.global_position
				global_position = global_position.lerp(target.global_position, follow_curve)

# OVERRIDE
func _process(delta: float) -> void:
	pass


func _shake() -> void:
	pass


func set_target(_target: Node2D) -> void:
	target = _target
	if _target:
		global_position = target.global_position
