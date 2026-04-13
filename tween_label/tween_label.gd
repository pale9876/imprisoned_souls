@tool
extends Label
class_name TweenAnimatedLabel

enum State{
	INIT,
	FADE_IN,
	FADE_OUT,
}


const FADE_IN_CURVE: Curve = preload("uid://buishkhyck2fd")
const FADE_OUT_CURVE: Curve = preload("uid://gf87g3ubwpn6")

const INIT: State = State.INIT
const FADE_IN: State = State.FADE_IN
const FADE_OUT: State = State.FADE_OUT

var _prev: State
@export var current: State = State.INIT: set = set_current

@export var fade_in_curve: Curve
@export var fade_out_curve: Curve
@export var max_dist: float = 30.


func set_current(value: State) -> void:
	if current == value: return
	
	current = value
	if value == State.INIT:
		set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		modulate.a = 1.
	elif value == State.FADE_OUT:
		if _prev == State.INIT or _prev == State.FADE_IN:
			fade_out()
	elif value == State.FADE_IN:
		if _prev == FADE_OUT:
			fade_in()

	_prev = value

func _init() -> void:
	fade_in_curve = FADE_IN_CURVE
	fade_out_curve = FADE_OUT_CURVE


func fade_in() -> void:
	var a_tween: Tween = create_tween()
	var pos_tween: Tween = create_tween()

	pos_tween.tween_property(
		self, "position:y", -max_dist, 1.
		).as_relative().from_current().set_custom_interpolator(
			func(value: float) -> float: return fade_in_curve.sample_baked(value)
		)
	
	a_tween.tween_property(
		self, "modulate:a", 1., 1.
		).set_custom_interpolator(
			func(value: float) -> float: return fade_in_curve.sample_baked(value)
		)


func fade_out() -> void:
	var pos_tween: Tween = create_tween()
	var a_tween: Tween = create_tween()
	
	pos_tween.tween_property(
		self, "position:y", max_dist, 1.
	).as_relative().from_current().set_custom_interpolator(
		func(value: float) -> float: return fade_out_curve.sample_baked(value)
	)
	
	a_tween. tween_property(
		self, "modulate:a", 0., 1.
	).set_custom_interpolator(
		func(value: float) -> float: return fade_out_curve.sample_baked(value)
	)
