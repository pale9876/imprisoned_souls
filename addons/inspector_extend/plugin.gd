@tool
extends EditorPlugin


var collide_info_editor_plugin: CollideInfoEditorPlugin = null
var battle_dialogue_editor_plugin: BattleDialogueEditorPlugin = null



func _enter_tree() -> void:
	collide_info_editor_plugin = CollideInfoEditorPlugin.new()
	battle_dialogue_editor_plugin = BattleDialogueEditorPlugin.new()
	
	add_inspector_plugin(collide_info_editor_plugin)
	add_inspector_plugin(battle_dialogue_editor_plugin)

func _exit_tree() -> void:
	remove_inspector_plugin(collide_info_editor_plugin)
	remove_inspector_plugin(battle_dialogue_editor_plugin)
