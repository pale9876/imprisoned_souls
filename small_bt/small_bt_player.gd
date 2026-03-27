extends RefCounted
class_name SmallBehaviorTreePlayer


const NOTIFICATION_AWAKENED: int = 32000
const NOTIFICATION_TICK: int = 32001


var tree: BehaviorTree


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_AWAKENED:
			pass
		
		NOTIFICATION_TICK:
			pass
