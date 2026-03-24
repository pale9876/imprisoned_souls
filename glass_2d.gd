@tool
extends Node2D
class_name ReflectableGlass2D


@export var polygon: PackedVector2Array
@export var reflect: bool = true
@export var reflect_region: Rect2 = Rect2(Vector2(-100., 100.), Vector2(100., 100.))

@export_group("DEBUG")
@export var debug: bool = true
@export var color: Color = Color(0.459, 0.597, 0.878, 1.0)


func _process(delta: float) -> void:
	pass



func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			var canvas_item: RID = get_canvas_item()
		

		NOTIFICATION_EXIT_TREE:
			pass


		NOTIFICATION_PROCESS:
			pass


		NOTIFICATION_DRAW:
			if debug:
				draw_polyline(
					get_polygon(true), color
				)
				
				draw_rect(
					reflect_region, Color.YELLOW
				)


func get_polygon(closed: bool) -> PackedVector2Array:
	return polygon


func get_image() -> Image:
	var image: Image = get_viewport().get_texture().get_image().get_region(reflect_region)
	
	return image
