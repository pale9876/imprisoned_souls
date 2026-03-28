@tool
extends EditorPlugin


var main_screen: Control


func _has_main_screen() -> bool:
	return main_screen != null


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
