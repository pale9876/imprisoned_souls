@tool
extends EEAD

@export var radius: float = 10.
@export var color: Color = Color(0.7, 0.329, 0.329, 0.447)


func create() -> void:
	RenderingServer.canvas_item_add_circle(
		get_canvas_item(), position, radius, color
	)
