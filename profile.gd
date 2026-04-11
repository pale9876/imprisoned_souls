@tool
extends Node2D
class_name CharacterProfile


@export var texture: Texture2D
@export var radius: float = 15.
@export var margin: float = 3.
@export var outline_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var bg_color: Color = Color(0.0, 0.12, 0.092, 1.0)


var background_cid: RID
var texture_cid: RID
var outline_cid: RID

var init: bool = false


@export_tool_button("Create", "2D") var _create: Callable = create


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		create()


func create() -> void:
	if init:
		kill()
	
	background_cid = RenderingServer.canvas_item_create()
	outline_cid = RenderingServer.canvas_item_create()
	texture_cid = RenderingServer.canvas_item_create()

	RenderingServer.canvas_item_set_parent(background_cid, get_canvas_item())
	RenderingServer.canvas_item_set_parent(texture_cid, background_cid)
	RenderingServer.canvas_item_set_parent(outline_cid, background_cid)
	
	var polygon: PackedVector2Array = PackedVector2Array()
	polygon.resize(5)
	
	polygon[0] = Vector2.LEFT * radius
	polygon[1] = Vector2.UP * radius
	polygon[2] = Vector2.RIGHT * radius
	polygon[3] = Vector2.DOWN * radius
	polygon[4] = Vector2.LEFT * radius

	
	# Set Outline
	RenderingServer.canvas_item_add_polyline(
		outline_cid, polygon, [outline_color], 1.
	)
	# Set Transparent Background
	RenderingServer.canvas_item_add_rect(
		background_cid,
		Rect2(- Vector2(radius * 2 + margin, radius * 2 + margin) / 2., Vector2(radius * 2 + margin, radius * 2 + margin)),
		Color(0.0, 0.0, 0.0, 0.0)
	)
	
	# Set Background Clip And Polygon
	RenderingServer.canvas_item_set_clip(background_cid, true)
	RenderingServer.canvas_item_add_polygon(
		background_cid,
		[polygon[0], polygon[1], polygon[2], polygon[3]],
		[bg_color],
	)
	
	if texture:
		RenderingServer.canvas_item_add_texture_rect(
			texture_cid, Rect2(- texture.get_size() / 2., texture.get_size()), texture.get_rid()
		)

	init = true


func kill() -> void:
	RenderingServer.free_rid(outline_cid)
	RenderingServer.free_rid(texture_cid)
	RenderingServer.free_rid(background_cid)
	
	init = false
