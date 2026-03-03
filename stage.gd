@tool
extends StaticBody2D
class_name Stage2D


@export var size: Vector2i = Vector2i(1., 1.)
@export var color: Color = Color(0.259, 0.784, 1.0, 0.102)


@export_group("진입 및 스폰 포인트")
@export var entrance_point: Array[Node2D]
@export var spawn_point: Array[Node2D]


func _init() -> void:
	pass


func _draw() -> void:
	draw_rect(
		Rect2i(Vector2i.ZERO, size),
		color,
		true
	)

func _notification(what: int) -> void:
	if NOTIFICATION_CHILD_ORDER_CHANGED == what:
		for node: Node in get_children():
			if node is CollisionPolygon2D:
				queue_redraw()
			
			if node is EntrancePoint2D:
				pass
	
