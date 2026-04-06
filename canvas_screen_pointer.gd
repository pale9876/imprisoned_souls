@tool
extends Node2D
class_name CanvasScreenPointer


var cid: RID
var polygon: PackedVector2Array
var init: bool = false

var arr: Array[Node2D]

func create() -> void:
	if init:
		kill()
	
	polygon = PackedVector2Array()
	
	polygon.resize(4)
	polygon.push_back(Vector2.ZERO)
	polygon.push_back(Vector2(get_viewport_rect().size.x, 0.))
	polygon.push_back(get_viewport_rect().size)
	polygon.push_back(Vector2(0., get_viewport_rect().size.y))
	
	init = true


func kill() -> void:
	RenderingServer.free_rid(cid)
	init = false


func add_target(_target: Node2D) -> void:
	arr.push_back(_target)


func _physics_process(_delta: float) -> void:
	for target in arr:
		var target_screen_coord: Vector2 = target.global_position + target.get_canvas_transform().origin
		
		if Geometry2D.is_point_in_polygon(target_screen_coord, polygon):
			global_position = target_screen_coord
		else:
			var point: Vector2 = Vector2()
			var seg_start := get_viewport_rect().get_center()
			for idx: int in range(polygon.size()):
				var result: Variant = Geometry2D.segment_intersects_segment(
					seg_start,
					target_screen_coord,
					polygon[idx],
					polygon[(
						idx + 1 if idx < polygon.size() - 1 else 0
					)]
				)
			
				if result != null: point = result
			
			global_position = point

func _exit_tree() -> void:
	if init:
		kill()


class I extends RefCounted:
	var cid: RID
	var position: Vector2
