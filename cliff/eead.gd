@tool
extends EEAD
class_name Cliff


const MIN_STEP: int = 8
const MAX_STEP: int = 256


@export_category("Ground Area")
@export var length: float = 256.:
	set(value):
		length = maxf(0., value)
@export var y_size: float = 256.
@export var texture: Texture2D


@export_category("Ground Line")
@export var has_area_outline: bool = true
@export var outline_color: Color = Color.WHITE
@export var width: float = - 1.


@export_category("Cliff")
@export var gradient: GradientTexture2D
@export_range(MIN_STEP, MAX_STEP) var step: int = 32
@export var min_height: float = 30.:
	set(value):
		min_height = maxf(0., value)
@export var max_height: float = 100.:
	set(value):
		max_height = maxf(min_height, value)


var path: Curve2D


func create() -> void:
	if init: kill()
	
	path = Curve2D.new()
	
	# Draw Cliff Ground
	var area_polygon: PackedVector2Array = PackedVector2Array()
	area_polygon.resize(4)
	area_polygon[0] = Vector2()
	area_polygon[1] = Vector2(0., y_size)
	area_polygon[2] = Vector2(length, y_size)
	area_polygon[3] = Vector2(length, 0.)
	
	RenderingServer.canvas_item_add_polygon(
		get_canvas_item(),
		area_polygon, [Color.WHITE], UV_DEFAULT, texture
	)
	
	# Draw Ground Line
	if has_area_outline:
		var area_points: PackedVector2Array = PackedVector2Array()
		area_points += area_polygon
		area_points.push_back(Vector2())
		
		RenderingServer.canvas_item_add_polyline(
			get_canvas_item(),
			area_points,
			[outline_color], width
		)
	
	# Create Gradient Progress Points
	var points: PackedVector2Array = PackedVector2Array()
	points.resize(step)
	
	for i: int in range(step):
		var progress: float = float(i) / float(step)
		var next: float = float(i + 1) / float(step) 
		var rand_h: float = min_height + randf_range(0., (max_height - min_height))
		var dist: Vector2 = Vector2(progress * length, y_size + rand_h + min_height)
		var next_dist: Vector2 = Vector2(next * length, y_size + rand_h + min_height)
		points[i] = dist
		
		var polygon: PackedVector2Array = PackedVector2Array()
		polygon.resize(4)
		
		polygon[0] = Vector2(dist.x, y_size)
		polygon[1] = Vector2(next_dist.x , y_size)
		polygon[2] = next_dist
		polygon[3] = dist
		
		RenderingServer.canvas_item_add_polygon(
			get_canvas_item(),
			polygon,
			[Color.WHITE],
			UV_DEFAULT, gradient
		)
	
	init = true


func kill() -> void:
	RenderingServer.canvas_item_clear(get_canvas_item())
