@tool
extends Resource
class_name CollideInformation


enum Shape
{
	CIRCLE,
	RAY,
	RECT,
}


const CIRCLE: Shape = Shape.CIRCLE
const RAY: Shape = Shape.RAY
const RECT: Shape = Shape.RECT


@export var shape: Shape = Shape.CIRCLE
@export var name: StringName = &""
@export var position: Vector2 = Vector2()
@export var size: Vector2 = Vector2(10., 10.)
@export var disabled: bool = true
