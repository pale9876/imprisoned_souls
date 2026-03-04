@tool
@abstract
extends PhysicsUnit2D
class_name Character


@export var emote_bt_module: BTPlayer
@export var inventory: Inventory
@export var chara_info: CharacterInformation
@export var hurtbox: Hurtbox2D
@export var ev_handler: EventHandler:
	set(handler):
		ev_handler = handler
		if ev_handler:
			ev_handler.owner = self


func _notification(what: int) -> void:
	super(what)
	match what:
		NOTIFICATION_POSTINITIALIZE:
			if !chara_info:
				chara_info = CharacterInformation.new()
		NOTIFICATION_READY:
			if !Engine.is_editor_hint():
				if hurtbox:
					hurtbox.area_shape_entered.connect(_area_entered)
					hurtbox.area_shape_exited.connect(_area_exited)


func load_character() -> void:
	pass


# OVERRIDE
func _area_entered(
	rid: RID, area: Area2D, area_shape_idx: int, local_shape_idx: int
) -> void:
	pass

# OVERRIDE
func _area_exited(
	rid: RID, area: Area2D, area_shape_idx: int, local_shape_idx: int
) -> void:
	pass



func check_hit(hitbox: Area2D, _target: Area2D) -> bool:
	if _중간에_물체가_있는지_확인(hitbox.global_position, _target.global_position, [hitbox.get_rid(), _target.get_rid()]):
		return false
	
	return true

func _중간에_물체가_있는지_확인(from: Vector2, to: Vector2, exclude: Array[RID]) -> bool:
	var param: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		from, to, collision_mask, exclude
	)
	
	var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(param)
	
	if !result.is_empty():
		pass
	
	return false


func get_chara_name() -> StringName:
	return chara_info.name if chara_info != null else &""
