# unit/state/idle.gd
extends UnitState


var move_state: UnitState
var fall_state: UnitState


func _enter_tree() -> void:
	#add_library()
	pass


func _enter() -> void:
	#var unit := agent as Unit
	move_state = get_state(^"Move")
	fall_state = get_state(^"Fall")
	#play(&"idle")
	
	#anim.play(&"idle")


func _update(_delta: float) -> void:
	var unit := get_unit()
	
	unit.velocity.x = move_toward(unit.velocity.x, 0., 15.5)

	if !is_on_floor():
		get_hsm().change_active_state(fall_state)

	move_and_slide()
