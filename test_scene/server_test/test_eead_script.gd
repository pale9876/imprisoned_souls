@tool
extends EEAD

@export var radius: float = 10.
@export var color: Color = Color(0.7, 0.329, 0.329, 0.447)


var child_cid: RID
var child_cid_2: RID

func create() -> void:
	RenderingServer.canvas_item_add_circle(
		get_canvas_item(), position, radius, color
	)
	
	child_cid = RenderingServer.canvas_item_create()
	child_cid_2 = RenderingServer.canvas_item_create()
	
	RenderingServer.canvas_item_set_parent(child_cid, get_canvas_item())
	RenderingServer.canvas_item_set_parent(child_cid_2, get_canvas_item())
	
	RenderingServer.canvas_item_set_draw_index(child_cid, 0)
	RenderingServer.canvas_item_set_draw_index(child_cid_2, 1)
	
	var rect: Rect2 = Rect2(Vector2(- 5., - 5.), Vector2(10., 10.))
	
	RenderingServer.canvas_item_add_rect(
		child_cid, rect, Color.WHITE
	)
