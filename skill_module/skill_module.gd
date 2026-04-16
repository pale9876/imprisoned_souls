@tool
extends RefCounted
class_name SkillModule


var owner: int

var list: Dictionary[String, Skill]


func add_skill(skill_name: String, skill: Skill) -> bool:
	if list.has(skill_name):
		list[skill_name] = skill
		return true

	return false


func kill_skill(skill_name: String) -> void:
	if list.has(skill_name):
		list[skill_name].kill()


func tick(delta: float) -> void:
	cooldown(delta)


func init(info: SkillInformation, node: Node = null) -> void:
	if node:
		owner = node.get_instance_id()

	list = info.skills


func cooldown(delta: float) -> void:
	for skill: Skill in list.values():
		if skill.cooltime > 0.:
			skill.cooldown(delta)


func boost(skill_name: String, data: Dictionary[String, Variant]) -> bool:
	if list.has(skill_name) and list[skill_name].active():
		list[skill_name].boost(data)
		return true
	
	return false


func kill() -> void:
	pass


class Observation:
	
	var skill: Skill
