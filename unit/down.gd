# unit/state/down.gd
extends UnitState


func _enter_tree() -> void:
	#add_library()
	pass


func _ready() -> void:
	get_anim().animation_finished.connect(_animation_finished)


func _enter() -> void:
	play(&"down")


func _update(delta: float) -> void:
	var hsm := get_state_machine()
	
	get_friction()
	
	move_and_slide()
	
	if hsm.unlocked():
		play(&"standup")


func _animation_finished(anim_name: StringName) -> void:
	#if anim_name == library_name + &"/standup":
		#get_state_machine().revert()
	pass
