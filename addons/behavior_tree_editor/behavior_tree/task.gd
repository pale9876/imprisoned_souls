@tool
extends Resource
class_name Task


const NOTIFICATION_SUCCESS: int = 52000
const NOTIFICATION_FAILED: int = 52001
const NOTIFICATION_RUNNING: int = 52002
const NOTIFICATION_TASK_ENTER: int = 52003
const NOTIFICATION_TASK_EXIT: int = 52004
const NOTIFICATION_TICK: int = 52005


const SUCCESS: Status = Status.SUCCESS
const FAILED: Status = Status.FAILED
const RUNNING: Status = Status.RUNNING


enum Status {
	FRESH = -1,
	FAILED = 0,
	SUCCESS = 1,
	RUNNING = 2,
}


@export var name: String:
	get = _get_name



var _status: Status


func _enter(data: Dictionary = {}) -> void:
	pass


# OVERRIDE
func _tick(delta: float) -> Status:
	return SUCCESS



func _exit(data: Dictionary = {}) -> void:
	pass


# Override
func _get_name() -> String:
	return "Task"
