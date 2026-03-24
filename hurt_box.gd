@tool
extends Node2D
class_name Hurtbox


var area_rid: RID
var colliders: Array[CollideInfo]


func _init() -> void:
	area_rid = PhysicsServer2D.area_create()


func _create_shape(shape_name: StringName) -> void:
	colliders.push_back(
		CollideInfo.new()
	)
