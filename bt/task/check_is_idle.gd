extends BTAction


func _enter() -> void:
	pass


func _tick(delta: float) -> Status:
	if agent is Character:
		if agent.pose_controller:
			var p_controller: PoseController2D = agent.pose_controller
			var current_pose: Pose2D = p_controller.get_current_pose()
			if current_pose.name == &"Idle":
				return SUCCESS
	
	return FAILURE
