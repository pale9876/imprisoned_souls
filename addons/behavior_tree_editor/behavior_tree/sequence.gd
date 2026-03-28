@tool
extends Task
class_name Sequence


const NOTIFICATION_SEQUENCE_ENTER: int = 53000
const NOTIFICATION_SEQUENCE_EXIT: int = 53001
const NOTIFICATION_SEQUENCE_FAILED: int = 53002


@export var task: Array[Task]


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TICK:
			pass
		
		NOTIFICATION_FAILED:
			pass
			
		NOTIFICATION_SEQUENCE_FAILED:
			print("Sequence Failed")


func _tick(delta: float) -> Status:
	var result: Status = Status.FRESH
	
	for _task in task:
		result = _task._tick(delta)
		if result == Status.FAILED:
			break
	
	return result



# Override
func _get_name() -> String:
	return "Sequence"
