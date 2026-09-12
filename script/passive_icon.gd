@tool
extends TextureRect
class_name PassiveSkillIcon


enum State {
	DISABLED,
	ACTIVATING,
	USED,
}

@export var passive_info: PassiveSkillInformation


var _owner: Node
var state: State


func _init() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	
	custom_minimum_size = Vector2(36., 36.)
	custom_maximum_size = Vector2(36., 36.)
	disable()


func initialize(user: Node) -> void:
	_owner = user


func disable() -> void:
	state = State.DISABLED
	
	if Engine.is_editor_hint(): return


func activate() -> void:
	state = State.ACTIVATING
	
	if Engine.is_editor_hint(): return


func use() -> void:
	state = State.USED
	
	if Engine.is_editor_hint(): return
