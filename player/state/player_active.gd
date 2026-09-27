extends PlayerState
class_name PlayerActive


@export var cooltime_frame: int = 8
@export var just_frame: bool = false
@export var hitbox_scene: PackedScene
@export var hitbox: Hitbox


var _punched: bool = false
var _kicked: bool = false
var _just: bool = true
var _anim_finished: bool = false
var _anim_names: PackedStringArray = PackedStringArray()


var _cooldown: int = 0:
	set(value):
		_cooldown = maxi(value, 0)
		if cooldowned():
			print("cooldowned")


func _guard() -> bool:
	var idle := get_state(^"Idle")
	var move := get_state(^"Move")
	
	if get_state_machine().get_active_state() in [idle, move] and cooldowned():
		return true
	
	return false


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			#init_action()
			#add_library()
			pass

			InputState.punch.connect(
				func() -> void:
					if is_active():
						_punched = true
			)
			
			InputState.kick.connect(
				func() -> void:
					if is_active():
						_kicked = true
			)


func _exit() -> void:
	_clear()
	heat()
	_substate = null


func _clear() -> void:
	hitbox.clear()
	_punched = false
	_anim_finished = false
	_just = false


func add_hitbox() -> void:
	hitbox = hitbox_scene.instantiate()
	
	var player := get_state_machine().get_parent() as Player
	var component: HitboxComponent = player.get_hitbox_component()
	if !component.has_hitbox(NodePath(hitbox.name)):
		component.add_hitbox(hitbox)


func cooldowned() -> bool:
	return _cooldown == 0


func tick() -> void:
	_cooldown -= 1


func heat() -> void:
	_cooldown = cooltime_frame


#func revert() -> bool:
	#return get_hsm().revert()


func is_hit(node_path: NodePath) -> bool:
	return hitbox.is_hit(node_path)


func get_hitbox_component() -> HitboxComponent:
	return (get_state_machine().get_parent() as Player).get_hitbox_component()
