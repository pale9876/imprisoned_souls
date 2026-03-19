extends BTAction


@export var tags: Array[String] = []


func _enter() -> void:
	pass


func _tick(delta: float) -> Status:
	return SUCCESS
