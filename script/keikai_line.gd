@tool
extends Node2D
class_name KeikaiSen

@export var map: Map
@export var color: Color = Color.WHITE:
	set(_color):
		color = _color
		_line.default_color = color

@export var texture: Texture2D:
	set(_texture):
		texture = _texture
		_line.texture = texture

@export_range(0, 128, 8) var radius: int = 64:
	set(val):
		radius = val
		_line.width = radius
		update_points()

@export var width: int = 2880:
	set(val):
		width = val
		update_points()

@export var height: int = 512:
	set(val):
		height = val
		update_points()


var _line: Line2D
var _tween: Tween

func _init() -> void:
	_line = Line2D.new()
	_line.closed = false
	_line.width = radius
	_line.texture = texture
	_line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	_line.default_color = Color.WHITE
	
	add_child(_line)
	
	update_points()


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	map.state_changed.connect(
		func() -> void:
			var _color := map.get_state_color()
			_tween = create_tween()
			_tween.tween_property(
				self, "color", _color, 1.
			)
	)


func _clear() -> void:
	_line.clear_points()


func update_points() -> void:
	if _line.points.size() > 0:
		_clear()
	
	for point: Vector2 in get_points():
		_line.add_point(point)


func get_points() -> Array[Vector2]:
	#var width_center: float = - float(radius) / 2.
	
	var _bl: Vector2 = Vector2(- 0., height)
	var _br: Vector2 = Vector2(width + 0., height)
	var _tl: Vector2 = Vector2(- 0., - 0.)
	var _tr: Vector2 = Vector2(width + 0., - 0.)
	
	return [_bl, _tl, _tr, _br]



	
