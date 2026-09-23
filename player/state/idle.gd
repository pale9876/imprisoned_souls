extends DefaultUnitFormState


func get_move_state() -> DefaultUnitFormState:
	return get_state(^"Move") as DefaultUnitFormState


func get_fall_state() -> DefaultUnitFormState:
	return get_state(^"Fall") as DefaultUnitFormState


func get_jump_state() -> DefaultUnitFormState:
	return get_state(^"Jump") as DefaultUnitFormState


func _enter_tree() -> void:
	#add_library()
	pass


func _enter() -> void:
	play(&"idle")


func _update(_delta: float) -> void:
	var player := get_player()
	var hsm := get_hsm()

	player.velocity.x = move_toward(player.velocity.x, 0., 25.)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = -450.
		change_state(get_jump_state())
		return

	if absf(player.get_input_direction().x) > .3:
		hsm.change_active_state(get_move_state())
		return

	if !is_on_floor():
		hsm.change_active_state(get_fall_state())
		return
	
