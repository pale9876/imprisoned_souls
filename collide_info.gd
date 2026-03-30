@tool
extends Resource
class_name CollideInfo


var _index: int = -1

var _shape: RID
var _owner: ManganiaUnit2D


@export var name: StringName = &""
@export var position: Vector2 = Vector2()
@export var size: Vector2 = Vector2(10., 10.)
@export var disabled: bool = true


func get_shape_rid() -> RID: return _shape

func get_owner() -> ManganiaUnit2D: return _owner
func get_index() -> int: return _index


func set_owner(unit: ManganiaUnit2D) -> void:
	_owner = unit


static func create(collider_name: StringName) -> CollideInfo:
	var res: CollideInfo = CollideInfo.new()
	
	res.name = collider_name
	res._shape = PhysicsServer2D.rectangle_shape_create()
	res.disabled = true

	return res
