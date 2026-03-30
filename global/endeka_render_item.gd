@tool
extends RefCounted
class_name EndekaRenderItem


const NOTIFICATION_TEXTURE_CHANGED: int = 47000
const NOTIFICATION_XFORM_CHANGED: int  = 47001


var ci_rid: RID
var xform: Transform2D:
	set(value):
		xform = value
		

@export var texture: Texture2D
@export var z: float = 0.


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TEXTURE_CHANGED:
			pass
	
		NOTIFICATION_XFORM_CHANGED:
			pass
	


func get_canvas_item_rid() -> RID:
	return ci_rid


func get_z_value() -> float:
	return z


func set_texture(value: Texture2D) -> void:
	texture = value
