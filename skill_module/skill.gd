@tool
extends Resource
class_name Skill


var module: SkillModule


@export var auto_boost: bool = false
@export var cooldown_time: float = .75

var turret: RID
var activate: bool = false

var cooltime: float = 0.:
	set(value):
		cooltime = maxf(value, 0.)


func create_turret() -> void:
	pass


func cooldown(delta: float) -> void:
	cooltime -= delta


func active() -> bool:
	return true


func boost(_cooldown: float, data: Dictionary[String, Variant] = {}) -> void:
	pass


func kill() -> void:
	if auto_boost:
		pass
