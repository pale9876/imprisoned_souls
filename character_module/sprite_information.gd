@tool
extends Resource
class_name SpriteInformation


@export var texture: Texture2D
@export var size: Vector2i = Vector2i(64, 64)
@export var frame: int = 0:
	set(value):
		if texture:
			var max_coord: Vector2i = Vector2i(texture.get_size()) / size
			var max_frame: int = max_coord.x * max_coord.y
			frame = clampi(frame, 0, max_frame)
		else:
			frame = 0
	get:
		return clampi(
			frame, 0, (Vector2i(texture.get_size()) / size).x * (Vector2i(texture.get_size()) / size).y
		) if texture else 0
@export var offset: Vector2i = Vector2i()
@export var coord: Vector2i = Vector2i(0, 0)
@export var coord_x: int:
	set(value):
		coord.x = value
	get: return coord.x
@export var coord_y: int:
	set(value):
		coord.y = value
	get: return coord.y
@export var draw_up: bool = true
@export var shader: ShaderMaterial = ShaderMaterial.new()


func draw(canvas_item: RID) -> void:
	RenderingServer.canvas_item_clear(canvas_item)
	
	RenderingServer.canvas_item_add_texture_rect_region(
		canvas_item, Rect2((Vector2(-size.x / 2., - size.y) if draw_up else size / 2.) + Vector2(offset), size),
		texture.get_rid(), Rect2(Vector2(size) * Vector2(coord), Vector2(size)),
		Color.WHITE
	)
