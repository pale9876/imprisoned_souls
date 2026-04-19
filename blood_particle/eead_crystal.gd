@tool
extends EEAD
class_name EEADCrystal


@export_category("Transform")
@export var size: Vector2 = Vector2(10., 10.)
@export var height: float = 50.

@export_category("Colors")
@export var color: Color = Color(0.735, 0.651, 0.88, 1.0)
@export var outline: Color = Color.WHITE
@export var width: float = -1.


func _enter_tree() -> void:
	create()


func create() -> void:
	if init:
		kill()
	
	RenderingServer.canvas_item_add_polyline(
		get_canvas_item(), _get_crystal_polygon_outline(), [outline], width
	)
	
	RenderingServer.canvas_item_add_polygon(
		get_canvas_item(), _get_crystal_polygon_outline(false), [color]
	)
	
	var inner_line: PackedVector2Array = _get_inner_lines()
	RenderingServer.canvas_item_add_multiline(get_canvas_item(), inner_line, [outline], width)
	
	init = true


func kill() -> void:
	RenderingServer.canvas_item_clear(get_canvas_item())


func _get_crystal_polygon_outline(closed: bool = true) -> PackedVector2Array:
	var _outline: PackedVector2Array = PackedVector2Array()
	_outline.resize(7 if closed else 6)
	
	_outline[0] = Vector2() # Bottom
	_outline[1] = Vector2(- (size.x / 2.), - size.y / 2.) # Bottom Left
	_outline[2] = Vector2( - (size.x / 2.), (- size.y / 2.) - height) # Top Left
	_outline[3] = Vector2(0., - size.y - height) # Top
	_outline[4] = Vector2((size.x / 2.), (- size.y / 2.) - height) # Top Right
	_outline[5] = Vector2((size.x / 2.), - size.y / 2.) # Bottom Right
	
	if closed: _outline[6] = _outline[0]
	
	return _outline



func _get_inner_lines() -> PackedVector2Array:
	var result: PackedVector2Array = PackedVector2Array()
	result.resize(6)
	
	var _outline: PackedVector2Array = _get_crystal_polygon_outline()
	
	result[0] = _outline[2]
	result[1] = _outline[3] + Vector2(0., size.y)
	
	result[2] = _outline[4]
	result[3] = _outline[3] + Vector2(0., size.y)
	
	result[4] = _outline[3] + Vector2(0., size.y)
	result[5] = _outline[0]
	
	
	return result
