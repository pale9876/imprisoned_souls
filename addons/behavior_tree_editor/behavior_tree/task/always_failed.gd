@tool
extends Task
class_name AlwaysFailed



func _tick(delta: float) -> Status:
	print("Test Always Failed")
	return FAILED
