@tool
extends Path2D
class_name ShaderPolygon


@export var shader: ShaderMaterial
@export var texture: Texture2D


var shader_cid: RID
var texture_cid: RID

var init: bool = false


@export_tool_button("Create Shader Canvas Item", "2D") var _create: Callable = create


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func _exit_tree() -> void:
	if init:
		kill()


func create() -> void:
	if init:
		kill()

	var polygon: PackedVector2Array = PackedVector2Array()
	polygon.resize(curve.point_count)
	for i: int in range(curve.point_count):
		var point: Vector2 = curve.get_point_position(i)
		polygon[i] = point
	
	if shader:
		shader_cid = RenderingServer.canvas_item_create()
		RenderingServer.canvas_item_add_polygon(
			shader_cid, polygon, [Color.WHITE], [Vector2(0., 0.), Vector2(1., 0.), Vector2(1., 1.), Vector2(0., 1.)]
		)
		RenderingServer.canvas_item_set_material(shader_cid, shader.get_rid())
		RenderingServer.canvas_item_set_parent(shader_cid, get_canvas_item())
	
	if texture:
		texture_cid = RenderingServer.canvas_item_create()
		RenderingServer.canvas_item_add_texture_rect(
			texture_cid, Rect2(- texture.get_size() / 2., texture.get_size()), texture.get_rid()
		)
		RenderingServer.canvas_item_set_parent(texture_cid, get_canvas_item())

	init = true


func kill() -> void:
	if texture:
		RenderingServer.free_rid(texture_cid)
	
	if shader_cid.is_valid():
		RenderingServer.free_rid(shader_cid)
