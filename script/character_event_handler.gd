@tool
extends EventHandler
class_name CharacterEventHandler


func _ev_handler(info: Dictionary) -> void:
	if info.has("Hit"):
		var type
	
