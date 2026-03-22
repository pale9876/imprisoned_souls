@tool
extends Resource
class_name CollideInfo


var _index: int = -1
var shape_rid: RID
var owner: ManganiaUnit2D

@export var name: StringName = &""
@export var position: Vector2 = Vector2()
@export var size: Vector2 = Vector2(10., 10.)
@export var disabled: bool = true


func get_shape_rid() -> RID: return shape_rid
func get_owner() -> ManganiaUnit2D: return owner
