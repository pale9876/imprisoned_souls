@tool
extends Resource
class_name SquadMember


@export var size: Vector2 = Vector2(10., 10.)
@export var position: Vector2 = Vector2()
@export var scope_range: Vector2 = Vector2(200., 100.)
@export var direction: float = 1.

@export_flags_2d_physics var mask: int = 1
@export_flags_2d_physics var layer: int = 0
