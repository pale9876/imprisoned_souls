@tool
extends EEAD
class_name EEADHexaheadron


@export var size: Vector2 = Vector2(20., 20.):
	set(value):
		size = value
		create()
@export var width: float = - 1.


@export_category("Color")
@export var color: Color = Color("ffffff89"):
	set(_color):
		color = _color
		create()
@export var outline_color: Color = Color.WHITE:
	set(_color):
		outline_color = _color
		create()
@export var height: float = 0.:
	set(value):
		height = value

func _enter_tree() -> void:
	create()


func draw() -> void:
	var origin: Vector2 = - (Vector2(size.x / 2., size.y))
	var upper_side: Rect2 = Rect2(Vector2(origin.x, origin.y - height), size)
	var side: Rect2 = Rect2(Vector2(origin.x, origin.y - height + size.y), Vector2(size.x, height))
	
	RenderingServer.canvas_item_add_rect(get_canvas_item(), upper_side, color)

	RenderingServer.canvas_item_add_rect(get_canvas_item(), side, color)

	RenderingServer.canvas_item_add_polyline(
		get_canvas_item(),
		_get_rect_polygon(upper_side), [outline_color]
	)

	RenderingServer.canvas_item_add_polyline(
		get_canvas_item(),
		_get_rect_polygon(side), [outline_color]
	)


func _get_rect_polygon(rect: Rect2) -> PackedVector2Array:
	var result: PackedVector2Array = PackedVector2Array()
	result.resize(5)
	
	result[0] = rect.position
	result[1] = Vector2(rect.position.x, rect.position.y + rect.size.y)
	result[2] = rect.position + rect.size
	result[3] = Vector2(rect.position.x + rect.size.x, rect.position.y)
	result[4] = rect.position

	return result 


func create() -> void:
	if init:
		kill()
	draw()
	
	init = true


func kill() -> void:
	RenderingServer.canvas_item_clear(get_canvas_item())
