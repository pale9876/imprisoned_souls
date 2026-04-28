@tool
extends Endeka


var grid: AStarGrid2D
var size: Vector2i = Vector2i(640, 360)
var cid: RID
var start_pos: Vector2i = Vector2i()

func _enter_tree() -> void:
	create_region(Rect2i(Vector2i(), size))
	var background_cid: RID = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(background_cid, get_canvas())
	RenderingServer.canvas_item_add_rect(background_cid, Rect2i(Vector2i(), size), Color(0.58, 0.157, 1.0, 0.188))
	cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(cid, get_canvas())


func _process(delta: float) -> void:
	if grid:
		if Input.is_action_just_pressed("click"):
			var point: Vector2 = DisplayServer.mouse_get_position()
			var global_mouse_pos: Vector2 = get_viewport().canvas_transform.affine_inverse().basis_xform(get_viewport().get_mouse_position())
			var path: PackedVector2Array = create_path(start_pos, global_mouse_pos)
			
			RenderingServer.canvas_item_clear(cid)
			
			for i: int in range(1, path.size() - 1):
				RenderingServer.canvas_item_add_line(
					cid, path[i], path[i + 1], Color.WHITE
				)
			
			RenderingServer.canvas_item_add_circle(cid, start_pos, 3., Color.WHITE)
			RenderingServer.canvas_item_add_circle(cid, global_mouse_pos, 3., Color.RED)

		elif Input.is_action_just_pressed("right_click"):
			start_pos = get_viewport().canvas_transform.affine_inverse().basis_xform(get_viewport().get_mouse_position())
			RenderingServer.canvas_item_clear(cid)
			RenderingServer.canvas_item_add_circle(cid, start_pos, 3., Color.WHITE)


func create_region(rect: Rect2i) -> void:
	grid = AStarGrid2D.new()
	grid.cell_size = Vector2i(1, 1)
	grid.cell_shape = AStarGrid2D.CELL_SHAPE_SQUARE
	grid.region = rect
	grid.update()


func area_set_disable(pos: Vector2, data: Variant) -> void:
	var radius: float = data as float
		
	var top: Vector2 = pos + Vector2(0., - radius)
	var left: Vector2 = pos + Vector2(- radius, 0.)
	var right: Vector2 = pos + Vector2(radius, 0.)
	var bottom: Vector2 = pos + Vector2(0., radius)
	
	var polygon: PackedVector2Array = PackedVector2Array([top, left, bottom, right])


func create_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	return grid.get_point_path(Vector2i(from), Vector2i(to))
