@tool
extends Node2D
class_name Hurtbox


@export var collider: Array[CollideInfo]


var area_rid: RID



func _init() -> void:
	area_rid = PhysicsServer2D.area_create()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			pass


func _create_shape(shape_name: StringName) -> void:
	pass
