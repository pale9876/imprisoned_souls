@tool
extends Control
class_name SlideContainer


var screens: Array[Control] = []


@export var _slide_tween_curve: Curve = Curve.new()

@export_tool_button("Next") var _next_slide: Callable = next
@export_tool_button("Previous") var _prev_slide: Callable = prev


@export var _progress: float = 0.:
	set(value):
		_progress = value
		_progress_changed()


var _slide_wait: bool = false


func _progress_changed() -> void:
	for i: int in range(screens.size()):
		screens[i].global_position.x = global_position.x + ((i % screens.size()) * size.x) - (_progress * size.x)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_CHILD_ORDER_CHANGED:
			screens = []
			
			var childs: Array[Control] = []
			
			for node: Node in get_children():
				if node is Control:
					childs.push_back(node)
			screens = childs
			
			_update()

		NOTIFICATION_RESIZED:
			_update()


func _update() -> void:
	var pos: Vector2 = global_position

	for i: int in range(screens.size()):
		var current: Control = screens[i]
		screens[i].set_size(self.get_size())
		screens[i].set_global_position(pos)
		pos.x += size.x


func next() -> void:
	tween_progress(_progress + 1.)


func prev() -> void:
	tween_progress(_progress - 1.)


func tween_progress(final_value: float) -> void:
	if _slide_wait: return
	
	var _tween: Tween = create_tween()
	
	_tween.tween_property(
		self, "_progress", final_value, 1.
	).set_custom_interpolator(
		func(value: float) -> float:
			return _slide_tween_curve.sample_baked(value)
	)
	
	_slide_wait = true
	
	await _tween.finished
	
	_slide_wait = false
