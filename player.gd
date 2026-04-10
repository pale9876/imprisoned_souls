@tool
extends EEAD2D
class_name Player





func _enter_tree() -> void:
	if !Engine.is_editor_hint(): create()


func create() -> void:
	pass


func kill() -> void:
	pass
