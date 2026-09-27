# board_rect.gd
@tool
extends TextureRect


var _prev_point: Vector2 = Vector2()
var _draw_start: bool = false


@export var brush_color: Color


func _init() -> void:
	clear()


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
				_prev_point = event.position
				_draw_start = true
		elif event.is_released():
			_draw_start = false

	elif event is InputEventMouseMotion:
		if _draw_start:
			var current_point: Vector2 = event.position
			var _line: Array[Vector2i] = Geometry2D.bresenham_line(
				_prev_point, current_point
			)
			
			for point: Vector2i in _line:
				var rect := Rect2(Vector2(point), Vector2(1., 1.))
				texture.blit_rect(rect, null, brush_color)
			
			_prev_point = current_point


func clear(wh: Vector2i = Vector2i(432, 208)) -> void:
	texture = DrawableTexture2D.new()
	texture.setup(
		wh.x, # 432,
		wh.y, # 208,
		DrawableTexture2D.DRAWABLE_FORMAT_RGBA8, Color.TRANSPARENT, false
	)
