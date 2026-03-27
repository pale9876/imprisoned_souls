@tool
extends Resource
class_name BehaviorTree


const Status := Task.Status

@export var sequence: Sequence


func _notification(what: int) -> void:
	match what:
		pass


#OVERRIDE
func _update(delta: float) -> Status:
	var result: Status = Status.SUCCESS
	
	for seq: Task in sequence.task:
		var _eval: Status = seq._tick(delta)
		
		if _eval == Status.FAILED:
			break

	return result
