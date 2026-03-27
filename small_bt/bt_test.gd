@tool
extends Node2D


var bt_player: SmallBehaviorTreePlayer
@export var behavior_tree: BehaviorTree


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	bt_player = SmallBehaviorTreePlayer.new()

func _physics_process(delta: float) -> void:
	if bt_player:
		bt_player
