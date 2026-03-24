@tool
extends EditorInspectorPlugin
class_name BattleDialogueEditorPlugin


func _can_handle(obj: Object) -> bool:
	return obj is CharacterBattleDialogue


func _parse_property(
	obj: Object,
	type: Variant.Type,
	name: String,
	hint_type: PropertyHint,
	hint_string: String,
	usage_flags: int,
	wide: bool
) -> bool:
	
	if name == "dialogues":
		add_property_editor(name, BattleDialogueProperty.new())
		return true
	
	return false


class BattleDialogueProperty extends EditorProperty:
	var _edit: CharacterBattleDialogue
	
	var _window: PopupPanel
	var show_editor_btn: Button
	var _container: TagDialogueContainer

	func _init() -> void:
		_window = PopupPanel.new()
		
		show_editor_btn = Button.new()
		


	



class BattleDialogueEditor extends MarginContainer:
	var tag_dialogue_containers: Dictionary[StringName, TagDialogueContainer] = {}
	


class TagDialogueContainer extends VBoxContainer:
	var edit: LineEdit
	var add_dialogue_btn: Button
