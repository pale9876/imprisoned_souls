@tool
extends CollisionShape2D
class_name NotificationShape2D


const DEFAULT_HURTBOX_COLOR: Color = Color("d100001a")
const DEFAULT_HITBOX_COLOR: Color = Color("29eee800")
const DEFAULT_COLLISION_COLOR: Color = Color("00c2921e")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PARENTED:
			_collider_changed_ev_handler()
		NOTIFICATION_VISIBILITY_CHANGED:
			_visibility_changed_ev_handler()
		NOTIFICATION_PATH_RENAMED:
			_renamed_ev_handler()


func _renamed_ev_handler() -> void:
	var parent: Node = get_parent()
	if parent != null:
		if parent is PhysicsUnit2D:
			parent._update()


func _collider_changed_ev_handler() -> void:
	var parent = get_parent()
	if parent is Hurtbox2D:
		debug_color = DEFAULT_HURTBOX_COLOR
	elif parent is PhysicsUnit2D:
		debug_color = DEFAULT_COLLISION_COLOR
	elif parent is Hitbox2D:
		debug_color = DEFAULT_HITBOX_COLOR


func _visibility_changed_ev_handler() -> void:
	disabled = !visible
	
	var parent: Node = get_parent()
	if parent is PhysicsUnit2D:
		pass
