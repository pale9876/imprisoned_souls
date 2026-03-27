@tool
extends Node2D


var bt_player: SmallBehaviorTreePlayer
@export var behavior_tree: BehaviorTree


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	bt_player = SmallBehaviorTreePlayer.new()
	bt_player.tree = behavior_tree
	bt_player.active = true


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if bt_player:
		bt_player._update(delta)
