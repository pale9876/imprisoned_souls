@tool
extends ColorRect
class_name FadeInOutRect


signal finished


var _tween: Tween


@export_tool_button("Test Fadein")
var test_fadein: Callable = func() -> void:
	fade_in()


@export_tool_button("Test Fadeout")
var test_fadeout: Callable = func() -> void:
	fade_out()


func _init() -> void:
	color = Color.TRANSPARENT


func fade_out(_color: Color = Color.WHITE, duration: float = 1.) -> void:
	if is_playing():
		return
	
	_tween = create_tween()
	_tween.tween_property(
		self, "color", _color, duration
	)
	
	_tween.finished.connect(
		func() -> void:
			_tween = null
			finished.emit()
	)


func fade_in(duration: float = 1.) -> void:
	if is_playing():
		return
	
	_tween = create_tween()
	
	_tween.tween_property(
		self, "color", Color.TRANSPARENT, duration
	)
	
	_tween.finished.connect(
		func() -> void:
			_tween = null
			finished.emit()
	)


func is_playing() -> bool:
	if _tween == null:
		return false
	
	if _tween.is_running():
		printerr("FADEINOUTRECT >> 효과 애니메이션이 진행중입니다.")
		return true
	
	return false
