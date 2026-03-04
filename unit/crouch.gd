@tool
extends Pose2D


@export var collider_init: String = "Crouch"
@export var hurtbox_init: String = "Crouch"

@export var idle_pose: Pose2D
@export var fall_pose: Pose2D



func _enter(_data: Dictionary = {}) -> void:
	if agent is Character:
		agent.change_collider("Crouch")
		agent.hurtbox.change_shape(&"Crouch")





func _fixed_update(_delta: float) -> void:
	var input_dir: Vector2 = get_agent_input_direction()
	
	if input_dir.y <= 0.:
		change_pose(idle_pose)
		return


func _exit() -> void:
	pass
