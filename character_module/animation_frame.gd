extends RefCounted
class_name AnimationFrame



var cid: RID
var texture: Texture2D
var size: Vector2
var coord: Vector2i = Vector2i(0, 0)


func draw(canvas_item: RID) -> void:
	RenderingServer.canvas_item_clear(canvas_item)
	
	RenderingServer.canvas_item_add_texture_rect_region(
		cid, Rect2(-size / 2., size),
		texture.get_rid(), Rect2(size * Vector2(coord), size),
		Color.WHITE
	)
