@tool
extends RefCounted
class_name BehaviorTreePlayer


const NOTIFICATION_AWAKENED: int = 32000
const NOTIFICATION_TICK: int = 32001
const Status := Task.Status


var tree: BehaviorTree

var agent: Node = null
var active: bool = false


var _status: Status = Status.FRESH


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_AWAKENED:
			pass
		
		NOTIFICATION_TICK:
			pass


func tree_init(_tree: BehaviorTree) -> void:
	tree = _tree


func _update(delta: float) -> void:
	if tree:
		tree._update(delta)
