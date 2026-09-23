extends DefaultUnitFormState
class_name PlayerState


func get_hsm() -> StateMachine:
	return get_root() as StateMachine


func get_anim() -> MotionLibrary:
	return (get_state_machine().get_player()).get_anim()


func add_library() -> void:
	if motion_info.library_name.is_empty():
		printerr("라이브러리 이름이 비어있습니다."  % [name])
		return
	
	if motion_info.anim_library == null:
		printerr("%s => 모션이 비어있습니다." % [name])
		return
	
	var _anim := get_anim()
	if !_anim.has_animation_library(motion_info.library_name):
		_anim.add_animation_library(motion_info.library_name, motion_info.anim_library)


func create_library() -> void:
	get_anim().add_animation_library(motion_info.library_name, AnimationLibrary.new())
	

func add_animation(_anim_name: StringName, anim: Animation) -> void:
	get_anim().get_animation_library(motion_info.library_name).add_animation(_anim_name, anim)


func play(_anim_name: StringName) -> void:
	get_anim().play(motion_info.library_name + &"/" + _anim_name)


func get_player() -> Player:
	return agent as Player


func is_on_floor() -> bool:
	return get_player().is_on_floor()


func move_and_slide() -> bool:
	return get_player().move_and_slide()


func execute_move(gravity: float = 1550., g_delta: float = 22.25, f_delta: float = 7.26) -> void:
	if force_duration > 0:
		move_and_collide(motion)
		force_duration -= 1
	else:
		get_friction(f_delta)
		get_gravity(gravity, g_delta)
		
		move_and_slide()


func get_gravity(max_y: float = 970., delta: float = 12.25) -> void:
	var player := get_player()
	player.velocity.y = move_toward(player.velocity.y, max_y, delta)


func get_friction(delta: float = 12.25) -> void:
	var player := get_player()
	player.velocity.x = move_toward(player.velocity.x, 0., delta)


func take_force(_motion: Vector2, duration: int) -> void:
	var player := get_player()
	
	motion = Vector2(_motion.x * player.get_face(), _motion.y)
	force_duration = duration


func take_motion(_motion: Vector2, duration: float) -> void:
	var player := get_player()
	#var shape_param := PhysicsShapeQueryParameters2D.new()
	#shape_param.shape_rid = player.get_collider().shape.get_rid()
	#shape_param.motion = _motion
	#shape_param.exclude = [player.get_rid()]
	#shape_param.transform = player.get_transform()
	#player.get_world_2d().direct_space_state.cast_motion(shape_param)
	var collider := move_and_collide(_motion, true)
	var _destination: Vector2 = collider.get_position()


func get_state_machine() -> StateMachine:
	return get_parent() as StateMachine


func move_and_collide(
	_motion: Vector2, test: bool = false, margin: float = .08
	) -> KinematicCollision2D:
	
	return get_player().move_and_collide(_motion, test, margin, false)


func is_on_wall() -> bool:
	return get_player().is_on_wall()


func _propel(_motion: Vector2) -> void:
	var player := get_player()
	var face: float = player.get_face()
	var input: float = player.input_state.direction.x
	var is_positive: bool = face > 0. and input > 0.
	var is_negative: bool = face < 0. and input < 0.
	#var is_conflict: bool = !is_positive and !is_negative
	var is_eq: bool = is_positive or is_negative
	
	
	var input_force := face * (.45 if input == 0. else 1. if is_eq else 0. )
	player.velocity = _motion * input_force


func anim_name(_name: StringName) -> StringName:
	return motion_info.library_name + &"/" + _name


func init_action() -> void:
	var state_machine := get_state_machine()
	state_machine.type_set_action(
		motion_info.type,
		motion_info.action_input,
		self,
		motion_info.ev_name,
		_guard
	)


# OVERRIDE
func _guard() -> bool:
	return true


# OVERRIDE
func _clear() -> void:
	pass


func _lock() -> void:
	get_player().input_state.lock()


func _unlock() -> void:
	get_player().input_state.unlock()


func revert() -> bool:
	return get_state_machine().revert()


func change_state(state: LimboState) -> void:
	get_hsm().change_active_state(state)
