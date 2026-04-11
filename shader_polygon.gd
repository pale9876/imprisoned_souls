@tool
extends Path2D
class_name ShaderPolygon


@export var inner_texture: Texture2D
@export var shader: ShaderMaterial
@export var texture: Texture2D


var inner_texture_cid: RID
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

	#inner_texture_cid = RenderingServer.canvas_item_create()
	#RenderingServer.canvas_item_add_polygon(
		#inner_texture_cid,
		#polygon,
		#[Color.WHITE],
		#[Vector2(0., 0.), Vector2(1., 0.), Vector2(1., 1.), Vector2(0., 1.)],
		#inner_texture.get_rid()
	#)
	#RenderingServer.canvas_item_set_parent(inner_texture_cid, get_canvas_item())


	shader_cid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_add_polygon(shader_cid, polygon, [Color.WHITE], [Vector2(0., 0.), Vector2(1., 0.), Vector2(1., 1.), Vector2(0., 1.)])
	RenderingServer.canvas_item_set_material(shader_cid, shader.get_rid())
	RenderingServer.canvas_item_set_parent(shader_cid, get_canvas_item())

	init = true


func kill() -> void:
	#RenderingServer.free_rid(inner_texture)
	RenderingServer.free_rid(shader_cid)


func create_uv() -> PackedVector2Array:
	var result: PackedVector2Array = PackedVector2Array()
	
	result.resize(curve.point_count)
	
	for i: int in range(curve.point_count):
		var point: Vector2 = curve.get_point_position(i)
		result[i] = point.normalized()
	
	return result
