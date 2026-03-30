extends RefCounted
class_name EndekaRenderItem


const NOTIFICATION_TEXTURE_CHANGED: int = 44000

var ci_rid: RID
var xform: Transform2D

@export var texture: Texture2D
@export var z: float = 0.


func get_canvas_item_rid() -> RID:
	return ci_rid


func get_z_value() -> float:
	return z


func set_texture(value: Texture2D) -> void:
	texture = value
