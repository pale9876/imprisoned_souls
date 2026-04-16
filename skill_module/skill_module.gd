@tool
extends RefCounted
class_name SkillModule


var owner: int
var list: Dictionary[String, Skill]


func add_skill(skill_name: String, skill: Skill) -> bool:
	if list.has(skill_name):
		list[skill_name] = skill
		skill.module = self
		return true

	return false


func kill_skill(skill_name: String) -> void:
	if list.has(skill_name):
		list[skill_name].kill()
		list.erase(skill_name)



func tick(delta: float) -> void:
	for skill: Skill in list.values():
		skill.cooldown(delta)
		if skill.auto_boost and skill.active():
			skill.boost(skill.cooldown_time)


func init(info: SkillInformation, node: Node = null) -> void:
	if node:
		owner = node.get_instance_id()

	list = info.skills
	
	for skill: Skill in list.values():
		skill.module = self


func boost(skill_name: String, cooldown_time: float, data: Dictionary[String, Variant]) -> bool:
	if list.has(skill_name) and list[skill_name].active():
		list[skill_name].boost(cooldown_time, data)
		return true
	
	return false


func kill() -> void:
	for skill: Skill in list.values():
		skill.kill()


class Observation:
	
	var skill: Skill
