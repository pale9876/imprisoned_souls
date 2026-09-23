# state_machine.gd
extends LimboHSM
class_name StateMachine


# Import
#const Idle: Script = preload("uid://c08p61o8pw6vo")
const Player: Script = preload("uid://c2uxhumgng18h")


# CONST EV
const EV_REVERT: StringName = &"revert"


@export var label: Label
var input: Vector2 = Vector2()


func _ready() -> void:
	var idle_state := get_state(^"Idle")
	add_transition(ANYSTATE, idle_state, EV_REVERT)

	active_state_changed.connect(
		func(current: LimboState, _prev: LimboState) -> void:
			if label:
				label.text = "State: %s" % current.name
	)


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



func get_current_type() -> PlayerState.Type:
	return current_state().type


func current_state() -> PlayerState:
	return get_active_state() as PlayerState


func get_active_states() -> Array[PlayerActive]:
	var result: Array[PlayerActive] = []
	var category: LimboState = get_node(^"#ActState")
	var start_idx: int = category.get_index() + 1
	var last_idx: int = get_children().size()
	
	result.resize(last_idx - start_idx)
	
	for i: int in range(last_idx - start_idx):
		result[i] = get_child(start_idx + i) as PlayerActive

	return result


func get_player() -> Player:
	return get_parent() as Player



func get_state(state_name: NodePath) -> DefaultUnitFormState:
	return get_node(state_name) as DefaultUnitFormState



func revert() -> bool:
	return dispatch(EV_REVERT)
