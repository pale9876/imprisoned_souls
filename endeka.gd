@tool
extends Endeka

var field: DetourField


func _enter_tree() -> void:
	field = DetourField.create(
		Rect2i(Vector2i(0, 0), Vector2i(640, 360))
	)
	


class DetourField:
	var rect: Rect2i
	var cell: Dictionary[Vector2i, Cell]


	static func create(_rect: Rect2i) -> DetourField:
		var _field = DetourField.new()
		_field.rect = _rect
		return _field
	
	
	func set_height(point: Vector2i, height: float) -> void:
		if !cell.has(point):
			cell[point] = Cell.new()
	
		cell[point].height = height
		
		var neighbors: PackedVector2Array = get_neighbors(point)


	func get_neighbors(point: Vector2i) -> PackedVector2Array:
		var result: PackedVector2Array = PackedVector2Array()
		
		if rect.has_point(point):
			var top_left: Vector2i = TL.call(point)
			var top: Vector2i = Vector2i(point.x, point.y - 1)
			var top_right: Vector2i = Vector2i(point.x + 1, point.y - 1)
			var left: Vector2i = Vector2i(point.x - 1, point.y)
			var right: Vector2i = Vector2i(point.x + 1, point.y - 1)
			var bottom_left: Vector2i = Vector2i(point.x - 1, point.y + 1)
			var bottom: Vector2i = Vector2i(point.x, point.y + 1)
			var bottom_right: Vector2i = Vector2i(point.x + 1, point.y + 1)
			
			var points: PackedVector2Array = PackedVector2Array([
				top_left, top, top_right,
				left, right,
				bottom_left, bottom, bottom_right
			])
			
			for p: Vector2 in points:
				if rect.has_point(p):
					result.push_back(p)
			
		return result
		
	var TL: Callable = func(p: Vector2i) -> Vector2i: return Vector2i(p.x - 1, p.y - 1)
	

class Cell:
	var direction: Vector2 = Vector2.ZERO
	var height: float = 0.
