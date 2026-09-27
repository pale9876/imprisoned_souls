extends PlayerActive


var idle: DefaultUnitFormState


#func _ready() -> void:
	#idle = get_state(^"Idle")


func _enter() -> void:
	play(&"jump_kick")
	

func _update(delta: float) -> void:
	move_and_slide()
	
	if !is_on_floor():
		get_gravity(970., 12.25)
	else:
		change_state(idle)


func _exit() -> void:
	pass
