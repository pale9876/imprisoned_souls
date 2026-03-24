@tool
extends Resource
class_name Perk

 
@export var perk_name: StringName
@export var icon: Texture2D
@export_multiline var expressions: PackedStringArray

var active: bool: get = is_active

# OVERRIDE
func is_active() -> bool:
	return false
