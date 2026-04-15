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
