@tool
extends GraphNode


func _ready() -> void:
	set_slot(
		0,
		true, 0, Color.RED,
		true, 0, Color.WHITE,
	)


func _on_resize_request(size: Vector2) -> void:
	pass


func _notification(what: int) -> void:
	pass
