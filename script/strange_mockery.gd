# skill/passive/strange_mockery.gd
extends AEIndex


@export_category("타이머 시간")
@export var active_effect_duration: float = 3.
@export var deactive_effect_duration: float = 5.


@export_category("활성화 시")
@export var increase_damage_ratio: float = .15


@export_category("비활성화 시")
@export var motion_increase: float = .1
@export var speed_increase: float = .1


@onready var active_timer: Timer = $ActiveTimer
@onready var deactive_timer: Timer = $DeactiveTimer


func enable(act_result: ActionResult = null) -> bool:
	assert(act_result, "ActionResult 값이 존재하지 않습니다.")
	return act_result.event == &"Aerial" and act_result.result == ActionResult.SUCCESS


func _enter_tree() -> void:
	var state_machine := get_unit().get_state_machine()
	
	state_machine.act_successed.connect(
		func(act_result: ActionResult) -> void:
			if enable(act_result):
				activate()
	)


func _ready() -> void:
	active_timer.timeout.connect(
		func() -> void:
			deactivate()
			updated.emit()
	)
	
	deactive_timer.timeout.connect(
		func() -> void:
			clear()
			updated.emit()
	)


func activate() -> void:
	stat.damage_ratio = increase_damage_ratio
	active_timer.start(active_effect_duration)
	updated.emit()


func deactivate() -> void:
	clear()
	stat.motion_speed = motion_increase
	stat.speed_ratio = speed_increase
	deactive_timer.start(deactive_effect_duration)
