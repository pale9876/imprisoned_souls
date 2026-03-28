@tool
extends Task
class_name AlwaysRunning



func _tick(_delta: float) -> Status:
	print("test Always running")
	return RUNNING
