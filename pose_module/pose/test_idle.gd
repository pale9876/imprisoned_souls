@tool
extends Pose
class_name TestIdle


@export var duration = 3.
var _duration = 0.


func enter(_data: Dictionary[String, Variant] = {}) -> void:
	if _data.has("duration"):
		_duration = _data["duration"]
	else:
		_duration = duration


func tick(_delta: float) -> void:
	_duration -= _delta
	if _duration < 0.:
		change_pose("test_finish")


func exit(_data: Dictionary[String, Variant] = {}) -> void:
	print("duration finished")
