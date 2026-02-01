@tool
extends Pose2D


enum {
	WALK,
	SPRINT,
}


@export var idle_pose: Pose2D
@export var fall_pose: Pose2D
@export var jump_pose: Pose2D


#func _enter() -> void:
	#if agent is PhysicsUnit2D:
		#agent.velocity.y = 0.


func _fixed_update(_delta: float) -> void:
	var input_dir: Vector2 = Vector2.ZERO
	var is_sprint: bool = Input.is_action_pressed("dash")
	
	if agent == InputHandler.player:
		input_dir = InputHandler.get_input_dir()
	
	if agent is PhysicsUnit2D:
		var dash_speed_scale: float = agent.get_information().dash_scale if is_sprint else 1.
		var unit_speed: float = agent.get_information().speed * input_dir.x * dash_speed_scale
		var current_speed: float = agent.velocity.x
		
		agent.velocity.x = move_toward(
			current_speed, unit_speed, _delta * agent.get_information().acceleration
		)

	if Input.is_action_just_pressed("jump"):
		change_pose(jump_pose)

	if input_dir == Vector2.ZERO:
		get_controller().change_pose(idle_pose)
		return
	
