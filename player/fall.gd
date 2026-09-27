extends PlayerState


var idle_state: LimboState
var move_state: LimboState


func _enter_tree() -> void:
	#add_library()
	pass


func _ready() -> void:
	idle_state = get_state_machine().get_state(^"Idle")
	move_state = get_state_machine().get_state(^"Move")


func _enter() -> void:
	#var player := get_player()
	#play(&"fall")
	pass


func _update(_delta: float) -> void:
	var player := get_player()

	player.velocity.x = move_toward(
		player.velocity.x, player.input_state.direction.x * 350., 15.
	)
	player.velocity.y = move_toward(player.velocity.y, 3100., 17.5)
	
	move_and_slide()
	
	if is_on_floor():
		if player.input_state.direction.x != 0.:
			change_state(move_state)
		else:
			change_state(idle_state)


func _exit() -> void:
	var player := get_player()
	
