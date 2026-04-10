@tool
extends Character
class_name PlayerCharacter


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	#InputHandler.player = self
