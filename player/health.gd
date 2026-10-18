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

	add_child(_timer)


func fade_in() -> void:
	_tween = create_tween()


func fade_out() -> void:
	_tween = create_tween()


func _enter_tree() -> void:
	var unit := get_unit()
	
	unit.stat.damaged.connect(
		func() -> void:
			pass
	)


func _damaged() -> void:
	pass


func get_unit() -> Unit:
	return get_parent() as Unit
