extends PlayerState


var idle_state: LimboState
var move_state: LimboState
var fall_state: LimboState


func _enter_tree() -> void:
	#add_library()
	pass


func _ready() -> void:
	idle_state = get_state(^"Idle")
	move_state = get_state(^"Move")
	fall_state = get_state(^"Fall")


func _enter() -> void:
	#var player := get_player()
	play(&"jump")


func _update(delta: float) -> void:
	var player := get_player()
	
	player.velocity.x = move_toward(player.velocity.x, 300. * player.input_state.direction.x, 10.5)
	player.velocity.y = move_toward(player.velocity.y, 970., 17.27)
	
	move_and_slide()

	if player.velocity.y > 0.:
		get_hsm().change_active_state(fall_state)
		return
	
	if is_on_floor():
		get_hsm().change_active_state(idle_state)
		return
