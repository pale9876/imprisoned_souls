# player.gd
@tool
extends Replicator
class_name Player


# Import
const PlayerCamera: Script = preload("uid://b7phyhue4y3yg")


@export_category("Data")
@export var info: UnitInformation


@export_group("Debug")
@export var toggles: Array[Node]


var _prefix: StringName = &""


func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, false)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)
	
	if Engine.is_editor_hint(): return
	
	state.face_changed.connect(_on_face_changed)


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	GSignal.soft_pause.connect(soft_pause)
	GSignal.resume.connect(resume)
	
	Global.debug_toggled.connect(
		func() -> void:
			for node: Node in toggles:
				if node is Node2D or node is Control:
					node.hide()
	)


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	if info:
		stat.name = name
		stat.hp = info.hp
		stat.speed = info.speed
	
	var state_machine := get_state_machine() as StateMachine
	var idle_state := state_machine.get_state(^"Idle")
	
	state_machine.initial_state = idle_state
	state_machine.initialize(self)
	state_machine.set_active(true)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return



func _exit_tree() -> void:
	pass


func _on_face_changed() -> void:
	if state.face.x != 0:
		get_sprite_component().scale.x = state.face.x


func get_input_direction() -> Vector2:
	return InputState.direction.round()


func get_face() -> float:
	return float(state.face.x)


func get_camera() -> PlayerCamera:
	return Global.player_camera


func get_stat() -> Stat:
	return stat


func get_blood() -> float:
	return stat.blood


func get_shadow() -> Sprite2D:
	return get_node(^"DropShadow") as Sprite2D


func get_hp_progress() -> float:
	return float(stat.hp) / float(stat.max_hp)


func get_input_dir() -> Vector2:
	return InputState.direction




	
