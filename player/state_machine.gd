# state_machine.gd
extends LimboHSM
class_name StateMachine


# CONST EV
const EV_REVERT: StringName = &"revert"


func _ready() -> void:
	var idle_state := get_state(^"Idle")
	add_transition(ANYSTATE, idle_state, EV_REVERT)


func get_states_from_category(category_path: NodePath) -> Array[LimboState]:
	assert(get_node(category_path) is CategoryComment)
	var result: Array[LimboState] = []
	var category: LimboState = get_node(category_path)
	
	var idx: int = category.get_index() + 1
	var _state := get_child(idx) as LimboState
	
	while _state is not CategoryComment:
		result.push_back(_state)
		idx += 1
		_state = get_child(idx) as LimboState
	
	return result


func _physics_process(_delta: float) -> void:
	pass


func has_state(node_path: String) -> bool:
	return get_node_or_null(node_path) != null


func current_state() -> PlayerState:
	return get_active_state() as PlayerState


func add_state(state: UnitState) -> void:
	pass


func get_active_states() -> Array[PlayerActive]:
	var result: Array[PlayerActive] = []
	var category: LimboState = get_node(^"#ActState")
	var start_idx: int = category.get_index() + 1
	var last_idx: int = get_children().size()
	
	result.resize(last_idx - start_idx)
	
	for i: int in range(last_idx - start_idx):
		result[i] = get_child(start_idx + i) as PlayerActive

	return result


func get_unit() -> Unit:
	return get_unit() as Unit


func get_player() -> Player:
	return get_parent() as Player


func get_input_vec() -> Vector2:
	return InputState.get_input_vector()


func get_body_velocity() -> Vector2:
	return get_unit().velocity


func get_state(state_name: NodePath) -> DefaultUnitFormState:
	return get_node(state_name) as DefaultUnitFormState


func revert() -> bool:
	return dispatch(EV_REVERT)
