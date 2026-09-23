@icon("res://icon/node/components/icon-comp-person.svg")
@abstract
extends LimboState
class_name DefaultUnitFormState


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const NitraAnime: Script = preload("uid://chb5h0vw5lpvq")

# PlaceHolder
const ANIM_LIB_PLACEHOLDER := preload("uid://h2rfntctgomi") as AnimationLibrary





@export var motion_info: UnitMotionInformation



var motion: Vector2 = Vector2()
var force_duration: int = 0:
	set(value):
		force_duration = maxi(value, 0)
		if force_duration == 0:
			motion = Vector2()


var _substate: LimboSubState


func has_substate(state_name: String) -> bool:
	return get_node_or_null(NodePath(state_name)) != null


func _init() -> void:
	#anim_library = ANIM_LIB_PLACEHOLDER
	#library_name = &"placeholder"
	pass

func change_sub_state(sub_state: LimboSubState) -> void:
	assert(sub_state, "%s => sub_state 값이 null입니다." % name)
	
	if _substate != null:
		_substate.exit()
	
	_substate = sub_state
	sub_state.enter()


# OVERRIDE
func _guard() -> bool:
	return true


# OVERRIDE
func _clear() -> void:
	pass
	
	
# OVERRIDE
func event(_ev: HitboxInformation, _result: HitResult) -> void:
	pass


# OVERRIDE
func set_hurt_data(_info: HitboxInformation) -> void:
	pass


func get_sub_states() -> Array[LimboSubState]:
	var result: Array[LimboSubState] = []
	for node: Node in get_children():
		if node is LimboSubState:
			result.push_back(node)
	
	return result


func get_sub_state(node_path: NodePath) -> LimboSubState:
	return get_node(node_path) as LimboSubState


func get_state(node_path: NodePath) -> LimboState:
	return get_hsm().get_node(node_path) as LimboState


func get_hsm() -> StateMachine:
	return get_parent() as StateMachine


func get_replicator() -> Replicator:
	return get_hsm().get_parent() as Replicator


func get_hurtbox() -> Hurtbox:
	return get_replicator().get_hurtbox()


func get_anim() -> MotionLibrary:
	return get_replicator().get_anim()


func play(anim_name: StringName) -> void:
	get_anim().play(motion_info.library_name + &"/" + anim_name)


func get_player() -> Player:
	return get_replicator() as Player


func is_on_floor() -> bool:
	return get_replicator().is_on_floor()

func move_and_slide() -> bool:
	return get_replicator().move_and_slide()


func move_and_collide(
	_motion: Vector2, test: bool = false, margin: float = .08
	) -> KinematicCollision2D:
	
	return get_replicator().move_and_collide(_motion, test, margin, false)

func change_state(state: LimboState) -> void:
	get_hsm().change_active_state(state)


func _propel(_motion: Vector2) -> void:
	var unit := get_replicator()
	unit.velocity = _motion


func create_animlib() -> AnimationLibrary:
	var anim_lib := AnimationLibrary.new()
	get_anim().add_animation_library(motion_info.library_name, anim_lib)
	
	return anim_lib


func add_library() -> void:
	get_anim().add_animation_library(motion_info.library_name, motion_info.anim_library)


func add_animation(anim_name: StringName, anim: Animation) -> void:
	var _lib := get_anim().get_animation_library(motion_info.library_name)
	_lib.add_animation(anim_name, anim)


func get_target() -> Node2D:
	return get_unit().get_btbb().get_var(&"target") as Node2D


func move_order_received() -> Array[Dictionary]:
	return get_unit().get_btbb().get_var(&"target_position") as Array[Dictionary]


func get_gravity(_max: float = 970., delta: float = 12.25) -> void:
	var unit := get_unit()
	unit.velocity.y = move_toward(unit.velocity.y, _max, delta)


func get_friction(delta: float = 12.25) -> void:
	var unit := get_unit()
	unit.velocity.x = move_toward(unit.velocity.x, 0., delta)


func get_unit() -> Unit:
	return agent as Unit





	
