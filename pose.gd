@tool
extends Resource
class_name Pose


const NOTIFICATION_POSE_ENTERED: int = 1500
const NOTIFICATION_POSE_EXITED: int = 1501
const NOTIFICATION_POSE_RENAMED: int = 1502


var agent: Node = null
var owner: PoseModule = null


@export var name: StringName = &"Pose":
	set(value):
		name = value
		notification(NOTIFICATION_POSE_RENAMED)


@export var disabled: bool = false
@export var data: Dictionary = {}


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_POSE_ENTERED:
			_enter(data)
			data = {}
		
		NOTIFICATION_POSE_EXITED:
			_exit(data)
			data = {}

		NOTIFICATION_POSE_RENAMED:
			if owner:
				owner.notification(PoseModule.NOTIFICATION_POSE_ORDER_CHANGED)


# OVERRIDE
func _enter(_data: Dictionary = {}) -> void:
	pass


# OVERRIDE
func _update(_delta: float) -> void:
	pass


# OVERRIDE
func _tick(_delta: float) -> void:
	pass


# OVERRIDE
func _exit(_data: Dictionary = {}) -> void:
	pass
