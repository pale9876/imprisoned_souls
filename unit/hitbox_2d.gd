@tool
extends Area2D
class_name Hitbox2D


@export var hitbox_info: HitboxInfo


@export var flip: bool = false:
	set(toggle):
		flip = toggle
		scale.x = - scale.x


var _cache: Array[Node2D] = []


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_POSTINITIALIZE:
			monitorable = false
		
		NOTIFICATION_ENTER_TREE:
			if !Engine.is_editor_hint():
				area_shape_entered.connect(_hurtbox_entered)
				area_shape_exited.connect(_hurtbox_exited)
		
		NOTIFICATION_VISIBILITY_CHANGED:
			_visibility_changed()

		NOTIFICATION_EXIT_TREE:
			_clear()


func _clear() -> void:
	pass


func _visibility_changed() -> void:
	for node: Node in get_children():
		if node is Node2D:
			node.visible = visible
			monitoring = visible


func _hurtbox_entered(
	area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int
	) -> void:
	
	if area is Hurtbox2D:
		var hurtbox_noti_shape_2d_id: int = area.shape_find_owner(area_shape_index)
		
		
		var agent: Node = area.get_root()
		if agent != null:
			if agent is Character:
				pass
				#agent.check_hit()


func _hurtbox_exited(
	area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int
	) -> void:
	
	if area is Hurtbox2D:
		#var other_shape_owner = area.shape_find_owner(area_shape_index)
		#var other_shape_node = area.shape_owner_get_owner(other_shape_owner)
#
		#var local_shape_owner = shape_find_owner(local_shape_index)
		#var local_shape_node = shape_owner_get_owner(local_shape_owner)

		var hurtbox_noti_shape_2d_id: int = area.shape_find_owner(area_shape_index)


func get_agent() -> Node:
	var parent: Node = get_parent()
	if parent is Pose2D:
		return parent.agent
	return null
