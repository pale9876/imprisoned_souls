@tool
extends Area2D
class_name Hurtbox2D


var _root: Node = null


@export_flags_2d_physics var mask: int = 0: set = set_mask


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		monitorable = visible
		
		for node: Node in get_children():
			if node is Node2D:
				node.visible = visible

func set_mask(value: int) -> void:
	mask = value
	collision_mask = mask
