@tool
extends Pose2D


@export var idle_pose: Pose2D
@export var fall_pose: Pose2D


@export var jump_height: float = 175.
@export var jump_ttp: float = .255
@export var jump_ttd: float = .167

@export var double_jump: bool = true


func _get_jump_velocity() -> float:
	return - ((2. * jump_height) / jump_ttp)


func _get_jump_gravity() -> float:
	return - ((- 2. * jump_height) / (jump_ttp ** 2))


func _get_fall_gravity() -> float:
	return - ((-2. * jump_height) / (jump_ttd ** 2))


func _get_aerial_gravity() -> float:
	return _get_jump_gravity() if agent.velocity.y < 0. else _get_fall_gravity()


func _enter(data: Dictionary = {}) -> void:
	var jump_velocity: float = _get_jump_velocity()
	
	if !data.is_empty():
		if data.has("jump"):
			jump_velocity = data["jump"]
	
	if agent is PhysicsUnit2D:
		agent.velocity.y = jump_velocity


func _fixed_update(_delta: float) -> void:
	if agent is PhysicsUnit2D:
		agent.velocity.y += _get_aerial_gravity() * _delta

		if double_jump and Input.is_action_just_pressed("jump"):
			pass

		if agent._on_floor:
			change_pose(idle_pose)
			double_jump = false
