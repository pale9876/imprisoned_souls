@tool
extends Pose2D


@export var move_pose: Pose2D
@export var fall_pose: Pose2D
@export var jump_pose: Pose2D
@export var crouch_pose: Pose2D


func _enter(data: Dictionary = {}) -> void:
	#var err: bool = hurtbox.change_shape(&"Idle")
	#if !err:
		#print()
	pass


func _fixed_update(_delta: float) -> void:
	var input_dir: Vector2 = Vector2.ZERO
	input_dir = get_agent_input_direction()

	if input_dir.x != 0.:
		get_controller().change_pose(move_pose)
		return
	
	_friction(_delta)

	if agent is PhysicsUnit2D:
		if agent._on_floor:
			if Input.is_action_just_pressed("jump"):
				change_pose(jump_pose)
				return
		else:
			get_controller().change_pose(fall_pose)
			return
	 


func _friction(_delta: float) -> void:
	if agent is PhysicsUnit2D:
		var current_speed: float = agent.velocity.x
		if current_speed != 0.:
			agent.velocity.x = move_toward (
				current_speed, 0., _delta * agent.get_information().friction
			)


func _exit() -> void:
	pass
