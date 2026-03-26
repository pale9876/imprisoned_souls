@tool
extends Node2D
class_name ViewportReplicator2D


@export var polygon: PackedVector2Array
@export var reflect: bool = true
@export var reflect_region: Rect2 = Rect2(Vector2(-100., 100.), Vector2(100., 100.))
@export var reflect_texture: Texture2D

# 무한복제 현상을 피하려면 이 객체의 Visibility Layer 값과 Cull Mask 값이 같지 않아야 함.
@export_flags_2d_render var cull_mask: int

@export_group("DEBUG")
@export var debug: bool = true
@export var color: Color = Color(0.459, 0.597, 0.878, 1.0)

var _viewport: RID
var _camera: RID


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if Engine.is_editor_hint(): return
			
			var canvas: RID = get_world_2d().canvas
			var canvas_item: RID = get_canvas_item()
			
			_viewport = RenderingServer.viewport_create()
			
			RenderingServer.viewport_set_size(_viewport, 100, 100)
			RenderingServer.viewport_attach_canvas(_viewport, canvas)
			
			RenderingServer.viewport_set_canvas_transform(
				_viewport, canvas, Transform2D(0., Vector2())
			)
			
			RenderingServer.viewport_set_canvas_cull_mask(_viewport, cull_mask)

			RenderingServer.viewport_set_active(_viewport, true)
			
			var texture_rid: RID = RenderingServer.viewport_get_texture(_viewport)
			
			#RenderingServer.canvas_item_add_texture_rect(
				#canvas_item, Rect2(Vector2(), Vector2(100., 100.)), texture_rid
			#)
			
			var test_polygon: PackedVector2Array = [
				Vector2(),
				Vector2(0., -200.),
				Vector2(-200., -200.),
				Vector2(-200., 0.)
			]
			
			#RenderingServer.canvas_item_add_triangle_array(
				#canvas_item,
				#_triangulate_polygon(get_polygon()), #Triangulate
				#get_polygon(), #points
				#PackedColorArray(), #Colors
				#get_polygon(), # UVS
				#PackedInt32Array(), # Bones
				#PackedFloat32Array(), # weights
				#texture_rid, # Texture RID
				#-1, # Count
			#)

			#var mesh: RID = RenderingServer.mesh_create()
			#RenderingServer.


			#RenderingServer.canvas_item_add_mesh(
				#canvas_item,
				#mesh
			#)
			
			RenderingServer.canvas_item_add_polygon(
				canvas_item,
				polygon,
				[], # Colors
				[
					
				],
				texture_rid
			)
			
			

		NOTIFICATION_EXIT_TREE:
			if Engine.is_editor_hint(): return
			
			if _viewport.is_valid():
				RenderingServer.free_rid(_viewport)


		NOTIFICATION_PROCESS:
			if Engine.is_editor_hint(): return


		NOTIFICATION_PHYSICS_PROCESS:
			pass


		NOTIFICATION_DRAW:
			if debug:
				draw_polyline(
					get_polygon(true), color
				)
				
				draw_rect(
					reflect_region, Color(0.81, 0.716, 0.478, 0.486)
				)
				



func get_polygon(closed: bool = false) -> PackedVector2Array:
	var result: PackedVector2Array = polygon.duplicate()
	if closed:
		result.push_back(result[0])
		
	return result


func create_uv(reversed_x: bool = false, reversed_y: bool = false) -> PackedVector2Array:
	var result: PackedVector2Array = get_polygon()

	return result


func _triangulate_polygon(_polygon : PackedVector2Array) -> PackedInt32Array:
	var size: int = int(polygon.size() / 2.)
	var result: PackedInt32Array = PackedInt32Array()
	
	for i in size - 1:
		result.append(i)
		result.append(size * 2 - 1 - i)
		result.append(size * 2 - 2 - i)
		result.append(i)
		result.append(i + 1)
		result.append(size * 2 - 2 - i)
	
	return result
