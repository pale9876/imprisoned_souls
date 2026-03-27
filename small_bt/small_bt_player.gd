@tool
extends RefCounted
class_name SmallBehaviorTreePlayer


const NOTIFICATION_AWAKENED: int = 32000
const NOTIFICATION_TICK: int = 32001
const Status := Task.Status


var tree: BehaviorTree

var agent: Node = null
var active: bool = false

var _status: Status



func _notification(what: int) -> void:
	match what:
		NOTIFICATION_AWAKENED:
			pass
		
		NOTIFICATION_TICK:
			pass


func _update(delta: float) -> void:
	if tree:
		tree._update(delta)
