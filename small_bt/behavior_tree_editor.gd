@tool
extends Tree
class_name BehaviorTreeEditor


const NOTIFICATION_TREE_CHANGED: int = 41000
const NOTIFICATION_SEQUENCE_ENTER: int = 41001


var tree: BehaviorTree = null


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SEQUENCE_ENTER:
			pass


func _update() -> void:
	pass


func change_tree(_res: BehaviorTree) -> void:
	if tree != _res:
		tree = _res
		notification(NOTIFICATION_TREE_CHANGED)
	
