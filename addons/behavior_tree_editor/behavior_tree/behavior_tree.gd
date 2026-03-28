@tool
extends Task
class_name BehaviorTree


@export var _root: Sequence = null


func _notification(what: int) -> void:
	match what:
		pass


func _update(delta: float) -> Status:
	if _status != Status.RUNNING:
		for _task: Task in _root.task:
			_status = _task._tick(delta)
			if _status == FAILED:
				break

	return _status


func _get_name() -> String:
	return "Behavior Tree Name"
