@tool
extends Resource
class_name Skill


@export var auto_boost: bool = false


var cooltime: float = 0.:
	set(value):
		cooltime = maxf(value, 0.)


func cooldown(delta: float) -> void:
	cooltime -= delta


func active() -> bool:
	return cooltime == 0.


func boost(data: Dictionary[String, Variant]) -> void:
	pass


func kill() -> void:
	pass
