@tool
extends Node2D
class_name ReflectableGlass2D


@export var polygon: PackedVector2Array
@export var reflect: bool = true
@export var reflect_region: Rect2 = Rect2(Vector2(-100., 100.), Vector2(100., 100.))
@export var reflect_texture: Texture2D

@export_group("DEBUG")
@export var debug: bool = true
@export var color: Color = Color(0.459, 0.597, 0.878, 1.0)

@export var subviewport: SubViewport

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
			#subviewport.world_2d = get_world_2d()
			#RenderingServer.canvas_item_clear(canvas_item)
			
			var canvas: RID = get_world_2d().canvas
			var canvas_item: RID = get_canvas_item()
			#var sub_canvas: RID = RenderingServer.canvas_create()
			
			_viewport = RenderingServer.viewport_create()
			
			RenderingServer.viewport_set_size(_viewport, 100, 100)
			RenderingServer.viewport_attach_canvas(_viewport, canvas)
			RenderingServer.viewport_set_active(_viewport, true)
			
			var rid: RID = RenderingServer.viewport_get_texture(_viewport)
			
			#var image: Image = RenderingServer.texture_2d_get(rid)
			#var texture: ImageTexture = ImageTexture.create_from_image(image)
			
			RenderingServer.canvas_item_add_texture_rect(
				canvas_item, Rect2(0., 0., 100., 100.), rid
			)
			
			
			
			pass


		NOTIFICATION_EXIT_TREE:
			if Engine.is_editor_hint(): return
			
			RenderingServer.free_rid(_viewport)


		NOTIFICATION_PROCESS:
			if Engine.is_editor_hint(): return
			
			var canvas_item: RID = get_canvas_item()
			
			#RenderingServer.canvas_item_clear(canvas_item)
			#


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
	return polygon


func get_image() -> void:
	var _image: Image = get_viewport().get_texture().get_image()
	var result: Image = _image.get_region(
			Rect2i(Vector2i(0, 0), Vector2i(200, 200))
		)
	
	if !reflect_texture:
		reflect_texture = ImageTexture.create_from_image(result)
	else:
		reflect_texture.update(result)
