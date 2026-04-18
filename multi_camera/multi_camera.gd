@tool
extends EEAD
class_name MultiCamera


@export_category("Do not test in Editor")
@export_custom(
	PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY
) var do_not_test: bool = true


@export var camera: Dictionary[String, Cam]
@export var current: String = "idle"


@export_tool_button("Draw Camera", "2D") var _draw_cameras: Callable = draw_camera_rect


func set_viewport_canvas_transform() -> void:
	if !camera.has(current): return
	
	var cam: Cam = camera[current]
	var vp_xform: Transform2D = Transform2D(
		0., Vector2.ONE * cam.zoom,
		0., (cam.position - (get_viewport().get_visible_rect().size * cam.zoom / 2.)).floor()
	)
	
	get_viewport().canvas_transform = vp_xform.affine_inverse()


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return


func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if !camera.is_empty():
		for cam: Cam in camera.values():
			if cam.target != null:
				var new_pos: Vector2 = cam.position.move_toward(
					cam.target.global_position, maxf(0., cam.position.distance_to(cam.target.global_position) - 10.) * delta * cam.speed
				).round()
				cam.position = cam.position.lerp(new_pos, .255)

	set_viewport_canvas_transform()


func _exit_tree() -> void:
	if init:
		for cam: String in camera:
			RenderingServer.free_rid(camera[cam].cid)


func draw_camera_rect() -> void:
	if init:
		kill()
		init = false
	
	if Engine.is_editor_hint():
		for cam: String in camera:
			#var cam_rect: Rect2 = camera[cam].rect
			camera[cam].cid = RenderingServer.canvas_item_create()
			RenderingServer.canvas_item_set_parent(camera[cam].cid, get_canvas_item())

			var viewport_size: Vector2 = Vector2(
				float(ProjectSettings.get("display/window/size/viewport_width")),
				float(ProjectSettings.get("display/window/size/viewport_height"))
			)
			
			var cam_rect: Rect2 = Rect2(Vector2(), viewport_size * camera[cam].zoom)
			
			RenderingServer.canvas_item_add_rect(
				camera[cam].cid,
				Rect2(- cam_rect.size / 2., cam_rect.size),
				camera[cam].color
			)
			
			RenderingServer.canvas_item_set_transform(
				camera[cam].cid,
				Transform2D(0., camera[cam].position)
			)
			
			RenderingServer.canvas_item_add_circle(
				camera[cam].cid, Vector2(), 3., Color.BLUE
			)
	
	init = true


func add_cam(camera_name: String, pos: Vector2, zoom: float, target: Node2D = null, color: Color = Color.WHITE) -> void:
	if camera.has(camera_name): return
	
	var cam: Cam = Cam.new()
	
	cam.cid = RenderingServer.canvas_item_create()
	cam.position = pos
	cam.zoom = zoom
	cam.color = color
	cam.target = target
	
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
