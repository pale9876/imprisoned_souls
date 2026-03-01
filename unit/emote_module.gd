extends Node2D
class_name EmoteModule


signal state_changed(current: String)


@export var emote_bt: BTPlayer

func _enter_tree() -> void:
	print()
