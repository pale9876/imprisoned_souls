# player/state/Dodge.gd
extends PlayerState


@export var just_time: bool = false
@export var slow_duration: float = .45


var _success: bool = false


func _enter_tree() -> void:
	init_action()
	add_library()


func _ready() -> void:
	var player := get_state_machine().get_player()
	player.get_hurtbox().dodged.connect(_on_dodge_successed)
	player.get_anim().animation_finished.connect(_on_dodge_anim_finsiehd)


func _enter() -> void:
	var hurtbox := get_player().get_hurtbox()
	hurtbox.state = hurtbox.DODGE
	
	play(&"dodge")


func _update(delta: float) -> void:
	get_friction()
	get_gravity()
	
	move_and_slide()
	
	if _success:
		if just_time:
			EventHorizon.player_dodged_ev(slow_duration)
		_success = false


func _exit() -> void:
	var hurtbox := get_player().get_hurtbox()
	hurtbox.state = hurtbox.IDLE
	
	_success = false


func _on_dodge_successed() -> void:
	_success = true


func _on_dodge_anim_finsiehd(anim_name: StringName) -> void:
	if anim_name == motion_info.library_name + &"/dodge":
		get_hsm().revert()
