@tool
extends Resource
class_name CharacterBattleDialogue


const NOTIFICATION_DIALOGUE_CHANGED: int = 22001


@export var dialogues: Dictionary[StringName, PackedStringArray] = {}


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DIALOGUE_CHANGED:
			pass


func add_tag(tag_name: StringName, init_dialogue: String) -> void:
	if !has_tag(tag_name):
		dialogues[tag_name] = []
	
	dialogues[tag_name].push_back(init_dialogue)
	notification(NOTIFICATION_DIALOGUE_CHANGED)


func has_tag(tag_name: StringName) -> bool:
	return dialogues.has(tag_name)


func get_dialogue(tag_name: StringName) -> String:
	if has_tag(tag_name):
		return Array(dialogues[tag_name]).pick_random()

	return ""
