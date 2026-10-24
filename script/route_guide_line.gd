@tool
extends Line2D
class_name RouteGuideLine


enum Direction
{
	LEFT = -1,
	RIGHT = 1,
}


@export var auto_play: bool = true
@export var alpha_curve: Curve

@export var point_color: Color = Color(0.914, 0.0, 0.0, 1.0):
	set(_color):
		point_color = _color


@export_range(0., 1., .001) var progress: float = 0.:
	set(value):
		progress = value
		update_offset()


@export_range(.015, .25, .001) var cursor_space: float = .02
@export var play_time: float = 1.25
@export var interval: float = 2.


@export_tool_button("Play Line", "LightmapProbe")
var _play: Callable = func() -> void:play_guideline()

@export_tool_button("Stop Line", "LightmapProbe")
var _stop: Callable = func() -> void: stop_guide()


var _timer: Timer
var _tween: Tween


func _init() -> void:
	_timer = Timer.new()
	alpha_curve = Curve.new()
	texture_mode = Line2D.LINE_TEXTURE_STRETCH
	
	var grad_texture := GradientTexture1D.new()
	grad_texture.gradient = Gradient.new()
	var b_color: Color = point_color
	b_color.a = 0.
	grad_texture.gradient.colors = [b_color, b_color, point_color, b_color, b_color]
	
	texture = grad_texture
	update_offset()
	
	_timer.timeout.connect(
		func() -> void:
			play_guideline()
	)
	
	add_child(_timer)


func update_offset() -> void:
	var cursur_min: float = clampf(progress - cursor_space, 0., 1.)
	var cursur_max: float = clampf(progress + cursor_space, 0., 1.)
	(texture as GradientTexture1D).gradient.offsets = [0., cursur_min, progress, cursur_max, 1.]
	
	var _arr: PackedColorArray = (texture as GradientTexture1D).gradient.colors
	var target_color := _arr[2]
	target_color.a = alpha_curve.sample_baked(progress)
	_arr[2] = target_color
	(texture as GradientTexture1D).gradient.colors = _arr


func play_guideline(진행방향: Direction = Direction.LEFT) -> void:
	progress = 0. if Direction.RIGHT else 1.
	
	if is_playing():
		return
	
	_tween = create_tween()
	_tween.tween_property(
		self, "progress", 1. if Direction.RIGHT else 0., play_time
	)
	_tween.finished.connect(
		func() -> void:
			_timer.start(interval)
	)


func stop_guide() -> void:
	if is_playing():
		var alpha_tween := create_tween()
		alpha_tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.)
		
		await _tween.finished
		
		_timer.stop()
	
	visible = false



func is_playing() -> bool:
	return _tween and _tween.is_running()


	
