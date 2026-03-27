@tool
extends Resource
class_name BehaviorTree


const Status := Task.Status


@export var name: String
@export var sequence: Sequence


var _status: Status = Status.FRESH


func _notification(what: int) -> void:
	match what:
		pass


func _update(delta: float) -> void:
	if _status != Status.RUNNING:
		for task: Task in sequence.task:
			pass
		



func _execute() -> void:
	pass
