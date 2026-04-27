@tool
extends Resource
class_name RoomInformation


enum Oreientation
{
	TOP,
	LEFT,
	BOTTOM,
	RIGHT,
	HORIZONTAL,
	VERTICAL,
	TOP_RIGHT,
	TOP_LEFT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}


@export var type: Orientation = HORIZONTAL
@export var pos: Vector2i = Vector2i()
@export var modulate: Color = Color.WHITE
@export var closed: bool = false
@export var disabled: bool = false


func draw() -> void:
	pass
