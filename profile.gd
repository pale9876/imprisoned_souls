@tool
extends Node2D
class_name CharacterProfile


@export var texture: Texture2D
@export var radius: float
@export var outline_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var bg_color: Color = Color(0.0, 0.12, 0.092, 1.0)


var background_cid: RID
var texture_cid: RID
var outline_cid: RID

var init: bool = false


@export_tool_button("Create", "2D") var _create: Callable = create


func create() -> void:
	if init:
		kill()
	
	background_cid = RenderingServer.canvas_item_create()
	outline_cid = RenderingServer.canvas_item_create()
	texture_cid = RenderingServer.canvas_item_create()

	var polygon: PackedVector2Array = PackedVector2Array()
	polygon.resize(5)
	
	polygon[0] = Vector2.LEFT * radius
	polygon[1] = Vector2.UP * radius
	polygon[2] = Vector2.DOWN * radius
	polygon[3] = Vector2.RIGHT * radius
	polygon[4] = Vector2.LEFT * radius





	init = true


func kill() -> void:
	RenderingServer.free_rid(outline_cid)
	RenderingServer.free_rid(texture_cid)
	RenderingServer.free_rid(background_cid)
	
	init = false
