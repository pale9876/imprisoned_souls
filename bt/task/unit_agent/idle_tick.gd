extends BTAction
class_name IdleTick


@export_range(1., 20., .01) var time: float = 1.
var _time: float = 0.


func _tick(delta: float) -> Status:
	if agent is Character:
		var pose_controller: PoseController2D = agent.pose_controller
		if pose_controller:
			if pose_controller.has_pose(&"Idle"):
				if pose_controller.get_current_pose().name == &"Idle":
					if _time > 0.:
						_time -= delta
						return RUNNING
					else:
						_time = time
						return SUCCESS
	
	_time = time
	return FAILURE
