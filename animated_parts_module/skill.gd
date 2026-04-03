extends Resource
class_name Skill


@export var name: String = ""
@export var cooldown: float = 1.
@export var size: float
@export var position: Vector2


var _hitbox: RID
var _shape: RID
var _cooldown: float = 0.


func active() -> void:
	pass


func enable() -> bool:
	return _cooldown <= 0.
