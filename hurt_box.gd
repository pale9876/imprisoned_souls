@tool
extends Node2D
class_name Hurtbox


const NOTIFICATION_COLLIDER_CHANGED: int = 24000


@export var collider: Array[HurtboxCollideInfo]


var _area: RID


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			var space_rid: RID = get_world_2d().space
			
			_area = PhysicsServer2D.area_create()
			
			PhysicsServer2D.area_set_space(_area, space_rid)
			PhysicsServer2D.area_attach_object_instance_id(_area, get_instance_id())


		NOTIFICATION_COLLIDER_CHANGED:
			pass


		NOTIFICATION_EXIT_TREE:
			if _area.is_valid():
				PhysicsServer2D.free_rid(_area)


func create_collider(shape_name: StringName) -> void:
	var info: CollideInfo = CollideInfo.create(shape_name)
	collider.push_back(info)


func remove_collider(res: Resource) -> void:
	pass


func get_area_rid() -> RID:
	return _area
