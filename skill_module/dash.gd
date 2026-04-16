@tool
extends Skill
class_name DashSkill



func boost(_cooldown: float, data: Dictionary[String, Variant] = {}) -> void:
	cooltime = _cooldown


func active() -> bool:
	return !activate and cooltime == 0.
