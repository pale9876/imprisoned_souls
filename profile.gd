@tool
extends Node2D
class_name CharacterProfile


@export var texture: Texture2D
@export var radius: float


var outline_cid: RID
var profile_cid: RID


var init: bool = false


@export_tool_button("Create", "2D") var _create: Callable = create


func create() -> void:
	if init:
		kill()
	
	outline_cid = RenderingServer.canvas_item_create()
	profile_cid = RenderingServer.canvas_item_create()


func kill() -> void:
	RenderingServer.free_rid(outline_cid)
	RenderingServer.free_rid(profile_cid)
	
	init = false
