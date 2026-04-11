@tool
extends EEAD2D

@export var texture: Texture2D

var sub_cid: RID


func create() -> void:
	if init:
		kill()
	
	if !texture: return
	
	sub_cid = RenderingServer.canvas_item_create()

	RenderingServer.canvas_item_add_texture_rect(
		sub_cid, Rect2(- texture.get_size() / 2., texture.get_size()), texture.get_rid()
	)
	
	RenderingServer.canvas_item_set_parent(
		sub_cid, get_canvas_item()
	)

	init = true


func kill() -> void:
	RenderingServer.free_rid(sub_cid)
