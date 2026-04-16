@tool
extends Pose
class_name Dash


@export var motion: Vector2 = Vector2()
@export var motion_curve: Curve2D = Curve2D.new()
@export var duration: float = .75


func enter(_data: Dictionary[String, Variant] = {}) -> void:
	if _data.has("force"):
		motion = _data["force"] as Vector2


func tick(_delta: float) -> void:
	pass
