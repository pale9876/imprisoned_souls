# player/health.gd
@tool
extends ProgressBar


const TRANSPARENT: Color = Color.TRANSPARENT
const WHITE: Color = Color.WHITE


var _timer := Timer.new()
var _tween: Tween


func _init() -> void:
	var is_edit: bool = Engine.is_editor_hint()
	
	show_percentage = false
	min_value = 0.
	max_value = 1.
	step = .001
	value = .5 if is_edit else 1.
	modulate = WHITE if is_edit else TRANSPARENT

	if Engine.is_editor_hint(): return
	
	_timer.timeout.connect(
		func() -> void:
			fade_out()
	)
	
	add_child(_timer)


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	var unit := get_unit()
	
	unit.stat.damaged.connect(
		func() -> void:
			pass
	)


func fade_in() -> void:
	_tween = create_tween()
	_tween.tween_property(
		self, "modulate", WHITE, .75
	)


func fade_out() -> void:
	_tween = create_tween()
	_tween.tween_property(
		self, "modulate", TRANSPARENT, .75
	)


func _damaged() -> void:
	fade_in()
	_timer.start(8.)


func get_unit() -> Unit:
	return get_parent() as Unit
