@tool
extends Resource
class_name IDDropped


static var id_count: int = 0


@export var id: int = -1


func _init() -> void:
	id = id_count
	id_count += 1
	get_class()
