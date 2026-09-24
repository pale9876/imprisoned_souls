extends PlayerActive


@export var enter_state_height: float = 55.5


var idle_state: PlayerState
var jump_state: PlayerState
var fall_state: PlayerState



func approved_position() -> bool:
	var player := get_player()
	var param: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		player.global_position,
		player.global_position + Vector2(0., 600.),
		1, [player.get_rid()]
	)
	var result := player.get_world_2d().direct_space_state.intersect_ray(param)
	if !result.is_empty():
		var collision_point := result["position"] as Vector2
		var dist := collision_point.y - player.global_position.y
		if collision_point.y - player.global_position.y > enter_state_height:
			return true
	
	
	return false


func _guard() -> bool:
	if get_state_machine().get_active_state() in [jump_state, fall_state] and approved_position():
		return true
	return false


func _ready() -> void:
	idle_state = get_idle_state()
	jump_state = get_jump_state()
	fall_state = get_fall_state()
	
	get_anim().animation_finished.connect(_on_anim_finished)


func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name in [
		&"/jump_hammer_ready",
		&"/jump_hammer",
		&"/delay"
	].map(func(value: StringName) -> StringName: return motion_info.library_name + value):
		_anim_finished = true


func _enter() -> void:
	play(&"jump_hammer_ready")


func _update(_delta: float) -> void:
	var player := get_player()
	
	move_and_slide()
	
	if !is_on_floor():
		player.velocity.y = move_toward(player.velocity.y, 970., 25.125)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0., 7.52)
	
	if is_on_floor():
		if _anim_finished:
			var current_anim := get_anim().assigned_animation
			
			if current_anim == motion_info.library_name + &"/jump_hammer_ready":
				play(&"jump_hammer")
				_anim_finished = false
				return
			
			if current_anim == motion_info.library_name + &"/jump_hammer":
				play(&"delay")
				_anim_finished = false
				return
			
			if current_anim == motion_info.library_name + &"/delay":
				change_state(idle_state)



func _exit() -> void:
	_anim_finished = false
