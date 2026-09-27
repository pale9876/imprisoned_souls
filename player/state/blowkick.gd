extends PlayerActive


var idle: PlayerState


#func _enter_tree() -> void:
	#idle = get_state(^"Idle")


func _ready() -> void:
	get_anim().animation_finished.connect(_animation_finished)


func _enter() -> void:
	play(&"blowkick")


func _update(_delta: float) -> void:
	execute_move()


func _animation_finished(_anim_name: StringName) -> void:
	if _anim_name == anim_name(&"blowkick"):
		get_hsm().revert()
