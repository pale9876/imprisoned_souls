@tool
extends Node2D
class_name MultiCamera


var camera: Dictionary[String, Cam] = {}


@export_tool_button("Draw Camera", "2D") var _draw_cameras: Callable = draw_camera_rect


@export var current: String = ""



func get_transform_to_fit(ct_rect: Rect2, v_rect: Rect2) -> Transform2D:
	var _scale: Vector2 = v_rect.size / ct_rect.size
	var translation: Vector2 = ct_rect.position - v_rect.position
	
	var min_scale: float = min(_scale.x, _scale.y)
	_scale = Vector2(min_scale, min_scale)
	
	var scaled_content_rect_size: Vector2 = ct_rect.size * _scale
	translation += (v_rect.size - scaled_content_rect_size) / 2
	
	var tf: Transform2D = Transform2D(0, _scale, 0, translation)
	
	return tf


func set_camera(rect: Rect2) -> void:
	rect.position = global_position - rect.size / 2.
	var cam_transform: Transform2D = get_transform_to_fit(rect, get_viewport_rect())
	
	get_viewport().canvas_transform = cam_transform.affine_inverse()


func camera_init() -> void:
	if !camera.is_empty():
		for cam: String in camera:
			set_camera(camera[cam].rect)


func _enter_tree() -> void:
	pass


func _process(delta: float) -> void:
	pass



func draw_camera_rect() -> void:
	if Engine.is_editor_hint():
		for cam: String in camera:
			var cam_rect: Rect2 = camera[cam].rect
			
			var polygon: PackedVector2Array = PackedVector2Array([
				cam_rect.position,
				Vector2(cam_rect.position.x, cam_rect.position.y + cam_rect.size.y),
				cam_rect.position + cam_rect.size,
				Vector2(cam_rect.position.x + cam_rect.size.x, cam_rect.position.y),
				cam_rect.position
			])
			
			RenderingServer.canvas_item_add_multiline(
				camera[cam].cid,
				polygon,
				[camera[cam].color],
				1.
			)


func add_cam(camera_name: String, rect: Rect2, target: Node2D = null, color: Color = Color.WHITE) -> void:
	if camera.has(camera_name): return
	
	var cam: Cam = Cam.new()
	cam.rect = rect
	cam.cid = RenderingServer.canvas_item_create()
	cam.target = target
	cam.color = color
	
	camera[camera_name] = cam


func erase_cam(camera_name: String) -> void:
	if camera.has(camera_name):
		RenderingServer.free_rid(camera[camera_name].cid)
		camera.erase(camera_name)


func _clear() -> void:
	camera = {}
	for cam: String in camera:
		erase_cam(cam)


func kill() -> void:
	for cam: String in camera:
		RenderingServer.free_rid(camera[cam].cid)


class Cam extends RefCounted:
	var cid: RID
	var rect: Rect2
	var target: Node2D
	var color: Color
