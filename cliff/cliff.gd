@tool
extends EEAD
class_name Cliff


const MIN_STEP: int = 8
const MAX_STEP: int = 256


@export var cliff_information: CliffInformation = CliffInformation.new()

func create() -> void:
	if init: kill()
	
	if !cliff_information.texture:
		return
	
	if !cliff_information.gradient:
		return
	
	var length: float = cliff_information.size.x
	
	# Draw Cliff Ground
	var area_polygon: PackedVector2Array = PackedVector2Array()
	area_polygon.resize(4)
	area_polygon[0] = Vector2()
	area_polygon[1] = Vector2(0., cliff_information.size.y)
	area_polygon[2] = Vector2(cliff_information.size.x, cliff_information.size.y)
	area_polygon[3] = Vector2(cliff_information.size.x, 0.)
	
	RenderingServer.canvas_item_add_polygon(
		get_canvas_item(),
		area_polygon, [Color.WHITE], UV_DEFAULT_HORIZONTAL, cliff_information.texture
	)
	
	# Draw Ground Line
	if cliff_information.has_area_outline:
		var area_points: PackedVector2Array = PackedVector2Array()
		area_points += area_polygon
		area_points.push_back(Vector2())
		
		RenderingServer.canvas_item_add_polyline(
			get_canvas_item(),
			area_points,
			[cliff_information.outline_color], cliff_information.width
		)
	
	# Create Gradient Progress Points
	var points: PackedVector2Array = PackedVector2Array()
	points.resize(cliff_information.step)
	
	
	
	for i: int in range(cliff_information.step):
		var progress: float = float(i) / float(cliff_information.step)
		var next: float = float(i + 1) / float(cliff_information.step) 
		var rand_h: float = cliff_information.max_height if (i == 0) or (cliff_information.step - 1) == i else cliff_information.min_height + randf_range(0., (cliff_information.max_height - cliff_information.min_height)) 
		var dist: Vector2 = Vector2(progress * length, cliff_information.size.y + rand_h)
		var next_dist: Vector2 = Vector2(next * length, cliff_information.size.y + rand_h)
		
		points[i] = dist
		
		var polygon: PackedVector2Array = PackedVector2Array()
		polygon.resize(4)
		
		polygon[0] = Vector2(dist.x, cliff_information.size.y)
		polygon[1] = Vector2(next_dist.x, cliff_information.size.y)
		polygon[2] = next_dist
		polygon[3] = dist
		
		RenderingServer.canvas_item_add_polygon(
			get_canvas_item(),
			polygon,
			[Color.WHITE],
			UV_DEFAULT_VERTICAL, cliff_information.gradient
		)
	
	init = true


func kill() -> void:
	RenderingServer.canvas_item_clear(get_canvas_item())
