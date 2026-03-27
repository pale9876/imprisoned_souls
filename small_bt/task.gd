@tool
extends Resource
class_name Task


enum Status {
	FAILED = 0,
	SUCCESS = 1,
	RUNNING = 2,
}


func _tick(delta: float) -> Status:
	return Status.SUCCESS
