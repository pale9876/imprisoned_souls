@tool
extends Resource
class_name CollideInfo


const NOTIFICATION_POSITION_CHANGED: int = 3201
const NOTIFICATION_SIZE_CHANGED: int = 3202

var _index: int = -1
var _shape: RID

@export var name: StringName = &""
@export var position: Vector2 = Vector2():
	set(value):
		position = value
		notification(NOTIFICATION_POSITION_CHANGED)
@export var size: Vector2 = Vector2(10., 10.):
	set(value):
		size = value
		notification(NOTIFICATION_SIZE_CHANGED)
@export var disabled: bool = true


func get_shape_rid() -> RID: return _shape

func remove() -> void:
	PhysicsServer2D.free_rid(_shape)
