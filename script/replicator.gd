extends CharacterBody2D
class_name Replicator


# Import
const SpriteComponent: Script = preload("uid://b0paoljcmbiys")
const SpriteModuler: Script = preload("uid://dbcsuysfwo30x")


@export var unit_info: UnitInformation

@export var z_value: float = 0.:
	set(val):
		if is_in_stage():
			var stage := get_stage()
			z_value = clampf(val, stage.z_min, stage.z_max)


var stat: Stat = Stat.new()
var state: Debite = Debite.new()


func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, false)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)


func soft_pause() -> void:
	set_process(false)
	set_physics_process(false)


func resume() -> void:
	set_process(true)
	set_physics_process(true)


func get_hitbox_component() -> HitboxComponent:
	return get_node(^"HitboxComponent") as HitboxComponent


func get_sprite_component() -> SpriteComponent:
	return get_node(^"SpriteComponent") as SpriteComponent


func get_state_machine() -> StateMachine:
	return get_node(^"StateMachine") as StateMachine


func get_sprite() -> AnimatedSprite2D:
	return get_sprite_component().sprite


func get_moduler() -> SpriteModuler:
	return get_sprite_component().moduler


func get_hurtbox() -> Hurtbox:
	return get_node(^"Hurtbox") as Hurtbox


func get_collider() -> CollisionShape2D:
	return get_node(^"UnitCollision") as CollisionShape2D


func get_anim() -> MotionLibrary:
	return get_node(^"MotionLibrary") as MotionLibrary


func get_stage() -> Stage:
	return get_parent() as Stage


func is_in_stage() -> bool:
	return get_parent() is Stage


func get_ae_library() -> AEIndexLibrary:
	return get_node(^"AEIndexLibrary") as AEIndexLibrary





func get_stat_effects() -> void:
	pass



	
