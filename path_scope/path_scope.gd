@tool
extends Resource
class_name PathScope


enum Type
{
	LINE,
	RECT,
	CIRCLE,
}


const PATH_TYPE_LINE: Type = Type.LINE
const PATH_TYPE_RECT: Type = Type.RECT
const PATH_TYPE_CIRCLE: Type = Type.CIRCLE


@export var path_type: Type = PATH_TYPE_LINE
@export var from: Vector2 = Vector2()
@export var to: Vector2 = Vector2(640., 380.)
@export var margin: float = 0.
@export var color: Color = Color(0.0, 0.475, 0.463, 0.38)


func draw_path(cid: RID) -> void:
	match path_type:
		PATH_TYPE_LINE:
			RenderingServer.canvas_item_add_line(
				cid, from, to, color, 1.
			)

		PATH_TYPE_RECT:
			RenderingServer.canvas_item_add_rect(
				cid, Rect2(from, to), color
			)

		PATH_TYPE_CIRCLE:
			var radius: float = from.distance_to(to)
			var polygon: PackedVector2Array = PackedVector2Array()
			polygon.resize(65)
			for i: int in range(64):
				polygon[i] = Vector2.from_angle(TAU * float(i)) * radius
			polygon[65] = polygon[0]
			
			RenderingServer.canvas_item_add_polygon(cid, polygon, [color])
