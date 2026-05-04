@tool
extends Endeka


@export_category("Background")
@export var background_wall_color: Color = Color.WHITE_SMOKE


@export_category("LeadLine")
@export var leadline_color: Color = Color.DARK_ORANGE
@export var line_offset: float
@export var start_position: float = 0.
@export var length: float = 100.


var background_wall: RID
var ground: RID


func create() -> void:
	get_viewport().world_2d.canvas
	background_wall = RenderingServer.canvas_item_create()
	ground = RenderingServer.canvas_item_create()
	
	RenderingServer.canvas_item_set_parent(get_canvas(), ground)
	
	notification(NOTIFICATION_CREATED)


class AASOHallway extends RefCounted:
	var background_wall: RID
	var ground: RID
	
	static func create() -> AASOHallway:
		var hallway: AASOHallway = AASOHallway.new()
		
		return hallway
	
	
	
	
	
	
	
